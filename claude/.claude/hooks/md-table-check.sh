#!/usr/bin/env bash
# PostToolUse(Edit|Write): 計画ファイル（~/.claude/plans 等）の .md の表だけを検査する（書き換えはしない）。
# 問題があれば stderr に書いて exit 2（exit 0 の stderr は Claude に届かない）。
f=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)
case "$f" in */.claude/plans/*.md) ;; *) exit 0 ;; esac
[ -f "$f" ] || exit 0
out=$(python3 "$HOME/.claude/hooks/md_table_check.py" "$f" 2>/dev/null) && exit 0
[ -z "$out" ] && exit 0
{
  echo "Markdown の表の検査で次の問題がある: $f"
  printf '%s\n' "$out" | head -n 20
  echo "列を減らす・転置する・節に分ける・セルを短くする・記号を語に置き換える、のどれかで直す。"
} >&2
exit 2
