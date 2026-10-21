#!/usr/bin/env bash
# So sánh .claude/rules/ của dự án với template của plugin, báo khi thiếu hoặc lệch.
# Bỏ qua frontmatter (paths) vì dự án được phép chỉnh riêng.
# Dự án chưa có file rule nào thì coi như chưa dùng plugin, không báo.

template_dir="${CLAUDE_PLUGIN_ROOT}/templates/rules"
project_dir="${CLAUDE_PROJECT_DIR:-$PWD}/.claude/rules"

strip_frontmatter() {
  awk 'NR == 1 && $0 == "---" { in_fm = 1; next } in_fm && $0 == "---" { in_fm = 0; next } !in_fm' "$1"
}

has_any=false
missing=()
outdated=()

for template in "$template_dir"/*.md; do
  name="$(basename "$template")"
  target="$project_dir/$name"

  if [[ ! -f "$target" ]]; then
    missing+=("$name")
    continue
  fi

  has_any=true

  if ! diff -q <(strip_frontmatter "$template") <(strip_frontmatter "$target") > /dev/null; then
    outdated+=("$name")
  fi
done

if [[ "$has_any" == false ]] || [[ ${#missing[@]} -eq 0 && ${#outdated[@]} -eq 0 ]]; then
  exit 0
fi

details=""
[[ ${#missing[@]} -gt 0 ]] && details+="thiếu ${missing[*]}; "
[[ ${#outdated[@]} -gt 0 ]] && details+="khác bản gốc của plugin tv: ${outdated[*]}; "
details="${details%; }"

message="[tv] .claude/rules/ chưa đồng bộ (${details}). Chạy /tv:init để đồng bộ."

printf '{"systemMessage": "%s", "hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": "%s Nhắc user việc này nếu task liên quan tới code hoặc tài liệu."}}\n' "$message" "$message"
