#!/usr/bin/env bash
set -euo pipefail

harness="${NUMADOS_HARNESS:-}"
strict=0
pi_dir="${PI_CODING_AGENT_DIR:-${HOME:?}/.pi/agent}"
codex_home="${CODEX_HOME:-${HOME:?}/.codex}"
claude_dir="${CLAUDE_CONFIG_DIR:-${HOME:?}/.claude}"
failures=0
warnings=0

usage() {
	cat <<'USAGE'
Usage: inspect-safety.sh --harness pi|codex|claude [--strict]

Read-only audit of the active harness's no-remote-Git-write boundary. It never
edits configuration or executes Git remote writes.
USAGE
}

while [ "$#" -gt 0 ]; do
	case "$1" in
		--harness) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; harness="$2"; shift 2;;
		--strict) strict=1; shift;;
		-h|--help) usage; exit 0;;
		*) printf 'Unknown argument: %s\n' "$1" >&2; usage >&2; exit 2;;
	esac
done

case "$harness" in pi|codex|claude) ;; '') printf '%s\n' '--harness is required; audit the active harness only' >&2; exit 2;; *) printf 'Unsupported harness: %s\n' "$harness" >&2; exit 2;; esac

ok() { printf '[x] %s\n' "$1"; }
warn() {
	warnings=$((warnings + 1))
	printf '[~] %s\n' "$1"
	if [ "$strict" -eq 1 ]; then failures=$((failures + 1)); fi
}
fail() { failures=$((failures + 1)); printf '[ ] %s\n' "$1"; }
unavailable() { fail "$1 unavailable"; }

check_pi() {
	if ! command -v pi >/dev/null 2>&1 && [ ! -e "$pi_dir" ]; then unavailable "Pi"; return; fi
	local extension="$pi_dir/extensions/no-git-push.ts"
	if [ ! -f "$extension" ]; then
		fail "Pi no-git-push extension missing: $extension"
		return
	fi
	if grep -Fq 'pi.on("tool_call"' "$extension" &&
		grep -Fq 'block: true' "$extension" &&
		grep -Fq 'REMOTE_GIT_WRITE' "$extension"; then
		ok "Pi tool-call boundary contains a hard remote-Git-write blocker"
	else
		fail "Pi extension does not contain the expected tool-call blocker"
	fi
	local pi_command pi_cli package_root
	pi_command="$(command -v pi 2>/dev/null || true)"
	if [ -n "$pi_command" ]; then
		pi_cli="$(readlink -f -- "$pi_command" 2>/dev/null || true)"
		package_root=""
		if [ -n "$pi_cli" ] && [ -f "$pi_cli" ]; then
			package_root="$(cd "$(dirname "$pi_cli")/.." 2>/dev/null && pwd -P || true)"
		fi
		if [ -n "$package_root" ] && [ -f "$package_root/dist/core/extensions/loader.js" ] &&
			PI_PACKAGE_ROOT="$package_root" PI_EXTENSION="$extension" node --input-type=module >/dev/null 2>&1 <<'NODE'
import { pathToFileURL } from "node:url";
import path from "node:path";

const loader = await import(pathToFileURL(path.join(process.env.PI_PACKAGE_ROOT, "dist/core/extensions/loader.js")));
const result = await loader.loadExtensions([process.env.PI_EXTENSION], process.cwd());
if (result.errors.length !== 0 || result.extensions.length !== 1) process.exit(1);

const extension = result.extensions[0];
const handlers = extension.handlers.get("tool_call");
if (!handlers || handlers.length === 0) process.exit(1);

const context = { ui: { notify() {} } };
const call = (command) => handlers[0]({
  type: "tool_call",
  toolCallId: "numados-skill-doctor",
  toolName: "bash",
  input: { command },
}, context);

const blocked = await call("git push origin main");
const allowed = await call("git status --short");
if (!blocked?.block || allowed?.block) process.exit(1);
NODE
		then
			ok "Pi native loader loads the blocker and blocks push while allowing status"
		else
			warn "Pi native extension-loader probe was unavailable or failed; static extension checks passed"
		fi
	else
		warn "Pi package loader was unavailable; static extension checks passed"
	fi
	warn "Pi's block is bypassed by an explicit --no-extensions invocation"
}

codex_config_contains_rule() {
	local config="$codex_home/config.toml"
	local reference="~/.codex/execpolicy/numados-safety.rules"
	[ -f "$config" ] || return 1
	node - "$config" "$reference" <<'NODE'
const fs = require("node:fs");
const [configPath, reference] = process.argv.slice(2);
const lines = fs.readFileSync(configPath, "utf8").split(/\r?\n/);
let inExecpolicy = false;
let found = false;
for (const line of lines) {
  const section = line.match(/^\s*\[([^\]]+)\]/);
  if (section) {
    inExecpolicy = section[1] === "execpolicy";
    continue;
  }
  if (inExecpolicy && !/^\s*#/.test(line) && line.includes(reference)) found = true;
}
process.exit(found ? 0 : 1);
NODE
}

codex_forbidden() {
	local label="$1"
	shift
	local output
	local status=0
	output="$(codex execpolicy check --rules "$codex_home/execpolicy/numados-safety.rules" --pretty "$@" 2>&1)" || status=$?
	if printf '%s\n' "$output" | grep -Eq '"decision"[[:space:]]*:[[:space:]]*"forbidden"'; then
		ok "Codex native policy blocks $label"
	else
		fail "Codex native policy does not block $label (exit $status)"
	fi
}

check_codex() {
	if ! command -v codex >/dev/null 2>&1 && [ ! -e "$codex_home" ]; then unavailable "Codex CLI"; return; fi
	local rule="$codex_home/execpolicy/numados-safety.rules"
	if [ ! -f "$rule" ]; then
		fail "Codex safety rule missing: $rule"
		return
	fi
	if codex_config_contains_rule; then
		ok "Codex config references the Numados execpolicy rule"
	else
		fail "Codex config does not load the Numados execpolicy rule"
	fi
	if ! command -v codex >/dev/null 2>&1; then
		warn "Codex CLI is unavailable; native rule evaluation was not run"
		return
	fi
	codex_forbidden "git push" git push origin main
	codex_forbidden "git push refspec" git push origin HEAD:main
	codex_forbidden "git send-pack" git send-pack origin refs/heads/main
	local safe_output
	local safe_status=0
	safe_output="$(codex execpolicy check --rules "$rule" --pretty git status --short 2>&1)" || safe_status=$?
	if printf '%s\n' "$safe_output" | grep -Eq '"decision"[[:space:]]*:[[:space:]]*"forbidden"'; then
		fail "Codex policy incorrectly blocks safe Git inspection"
	else
		ok "Codex policy leaves safe Git inspection available"
	fi
	local wrapper_output
	local wrapper_status=0
	wrapper_output="$(codex execpolicy check --rules "$rule" --pretty /bin/bash -lc "git push origin main" 2>&1)" || wrapper_status=$?
	if printf '%s\n' "$wrapper_output" | grep -Eq '"decision"[[:space:]]*:[[:space:]]*"forbidden"'; then
		ok "Codex policy blocks the tested shell wrapper"
	else
		warn "Codex prefix policy does not prove shell-wrapper coverage (exit $wrapper_status)"
	fi
}

claude_hook_configured() {
	local settings="$claude_dir/settings.json"
	node - "$settings" <<'NODE'
const fs = require("node:fs");
const settings = JSON.parse(fs.readFileSync(process.argv[2], "utf8"));
const groups = settings.hooks?.PreToolUse;
const expected = "~/.local/share/numados/hooks/deny-git-push.mjs";
const found = Array.isArray(groups) && groups.some((group) =>
  group && (group.matcher === "Bash" || group.matcher === "*") &&
  Array.isArray(group.hooks) && group.hooks.some((hook) => hook?.command === expected),
);
process.exit(found ? 0 : 1);
NODE
}

check_claude() {
	if ! command -v claude >/dev/null 2>&1 && [ ! -e "$claude_dir" ]; then unavailable "Claude Code"; return; fi
	local settings="$claude_dir/settings.json"
	local hook="$HOME/.local/share/numados/hooks/deny-git-push.mjs"
	if [ ! -f "$settings" ]; then
		fail "Claude Code settings missing: $settings"
		return
	fi
	if ! node -e 'JSON.parse(require("node:fs").readFileSync(process.argv[1], "utf8"))' "$settings" >/dev/null 2>&1; then
		fail "Claude Code settings are invalid JSON: $settings"
		return
	fi
	ok "Claude Code settings parse"
	if node - "$settings" <<'NODE'
const fs = require("node:fs");
const settings = JSON.parse(fs.readFileSync(process.argv[2], "utf8"));
const deny = settings.permissions?.deny;
const denyPush = Array.isArray(deny) && (deny.includes("Bash(git push *)") || deny.includes("Bash(git push:*)"));
const bypassDisabled = settings.disableBypassPermissionsMode === "disable";
process.exit(denyPush && bypassDisabled && settings.disableAllHooks !== true ? 0 : 1);
NODE
	then
		ok "Claude Code native deny and bypass-disable settings are active"
	else
		fail "Claude Code deny, bypass-disable, or hook-enable setting is missing"
	fi
	if claude_hook_configured; then
		ok "Claude Code PreToolUse safety hook is configured"
	else
		fail "Claude Code PreToolUse safety hook is not configured"
	fi
	if [ ! -x "$hook" ]; then
		fail "Claude Code safety hook is missing or not executable: $hook"
		return
	fi
	local push_status=0
	printf '%s' '{"tool_name":"Bash","tool_input":{"command":"git push origin main"}}' | "$hook" >/dev/null 2>&1 || push_status=$?
	if [ "$push_status" -eq 2 ]; then ok "Claude safety hook blocks git push"; else fail "Claude safety hook did not block git push (exit $push_status)"; fi
	local safe_status=0
	printf '%s' '{"tool_name":"Bash","tool_input":{"command":"git status --short"}}' | "$hook" >/dev/null 2>&1 || safe_status=$?
	if [ "$safe_status" -eq 0 ]; then ok "Claude safety hook leaves git status available"; else fail "Claude safety hook blocks safe Git inspection (exit $safe_status)"; fi
	warn "Verify the active Claude settings layers in /status; project, local, managed, and CLI layers are outside this file-only probe"
}

case "$harness" in
	pi) check_pi;;
	codex) check_codex;;
	claude) check_claude;;
esac

if [ "$failures" -gt 0 ]; then
	printf 'Safety status: BLOCKED (%s issue(s), %s warning(s))\n' "$failures" "$warnings"
	exit 1
elif [ "$warnings" -gt 0 ]; then
	printf 'Safety status: READY WITH GAPS (%s warning(s))\n' "$warnings"
	else
	printf '%s\n' 'Safety status: READY'
fi
