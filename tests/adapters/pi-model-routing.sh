#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../.." && pwd -P)"
apply_script="$repo_root/adapters/pi/apply-model-routing.sh"
temporary_root="$(mktemp -d)"
trap 'rm -rf "$temporary_root"' EXIT

pi_dir="$temporary_root/pi-agent"
backup_dir="$temporary_root/backups"
mkdir -p "$pi_dir/agents" "$pi_dir/skills/model-router"
printf '%s\n' '{"customSetting":true,"defaultModel":"old-model"}' > "$pi_dir/settings.json"
printf '%s\n' 'user-managed agent' > "$pi_dir/agents/user.md"

PI_CODING_AGENT_DIR="$pi_dir" \
NUMADOS_PI_BACKUP_DIR="$backup_dir" \
  "$apply_script"

node - "$pi_dir/settings.json" <<'NODE'
const fs = require("node:fs");
const settings = JSON.parse(fs.readFileSync(process.argv[2], "utf8"));
if (settings.customSetting !== true) throw new Error("custom setting was lost");
if (settings.defaultProvider !== "zai-coding-cn") throw new Error("provider mismatch");
if (settings.defaultModel !== "glm-5.2") throw new Error("model mismatch");
if (settings.defaultThinkingLevel !== "xhigh") throw new Error("thinking mismatch");
NODE

grep -q '^model: deepseek/deepseek-v4-flash$' "$pi_dir/agents/scout.md"
grep -q '^thinking: low$' "$pi_dir/agents/scout.md"
grep -q '^model: zai-coding-cn/glm-5.2$' "$pi_dir/agents/planner.md"
grep -q '^thinking: xhigh$' "$pi_dir/agents/planner.md"
grep -q '^model: zai-coding-cn/glm-5.2$' "$pi_dir/agents/reviewer.md"
grep -q '^thinking: xhigh$' "$pi_dir/agents/reviewer.md"
grep -q '^user-managed agent$' "$pi_dir/agents/user.md"
test -f "$backup_dir/settings.json"

node - "$repo_root/adapters/pi/model-routing.json" <<'NODE'
const fs = require("node:fs");
const routing = JSON.parse(fs.readFileSync(process.argv[2], "utf8"));
const codex = routing.external_tools.codex;
if (codex.light.model !== "gpt-5.6-luna" || codex.light.reasoning_effort !== "max") {
  throw new Error("light Codex route mismatch");
}
if (codex.complex.model !== "gpt-5.6-sol" || codex.complex.reasoning_effort !== "high") {
  throw new Error("complex Codex route mismatch");
}
if (routing.agents.planner.model !== "zai-coding-cn/glm-5.2" || routing.agents.planner.thinking !== "xhigh") {
  throw new Error("planner route mismatch");
}
if (routing.external_tools.agy.selection !== "fixed") throw new Error("AGY route is not fixed");
NODE

printf '%s\n' 'PASS Pi adapter model-routing checks'
