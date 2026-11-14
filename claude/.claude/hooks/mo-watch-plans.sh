#!/usr/bin/env bash
# SessionStart: mo で計画ファイル（~/.claude/plans）を監視しておく。mo が無ければ何もしない。
# 既に mo サーバーが動いていれば監視パターンを足すだけ。ブラウザは開かない。
command -v mo >/dev/null 2>&1 || exit 0
mkdir -p "$HOME/.claude/plans"
mo -w "$HOME/.claude/plans/*.md" --no-open >/dev/null 2>&1 || true
exit 0
