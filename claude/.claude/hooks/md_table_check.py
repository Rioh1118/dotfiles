#!/usr/bin/env python3
"""Markdown の表を検査する。markdownlint が拾えない点だけを見る。
- 区切り行のない表（GFM では表にならず段落になる）
- 列数の上限
- セルの表示幅（全角=2）
- セル内の East Asian Ambiguous 記号
違反を1行ずつ stdout に出し、違反があれば exit 1。
"""
import re, sys, unicodedata

MAX_COLS = 6          # 上限。推奨は5
MAX_CELL_WIDTH = 40   # 表示幅（全角20字）
SEP = re.compile(r'^\s*\|?\s*:?-+:?\s*(\|\s*:?-+:?\s*)*\|?\s*$')

def width(s):
    return sum(2 if unicodedata.east_asian_width(c) in "WF" else 1 for c in s)

def cells(line):
    s = line.strip()
    s = re.sub(r'`[^`]*`', lambda m: m.group(0).replace('|', ' '), s)  # コードスパン内の | を無視
    s = s.replace('\\|', '  ')
    if s.startswith('|'): s = s[1:]
    if s.endswith('|'): s = s[:-1]
    return [c.strip() for c in s.split('|')]

def check(path):
    out = []
    lines = open(path, encoding='utf-8').read().splitlines()
    in_code = False
    i = 0
    while i < len(lines):
        ln = lines[i]
        if ln.lstrip().startswith(('```', '~~~')):
            in_code = not in_code; i += 1; continue
        if in_code or not ln.lstrip().startswith('|'):
            i += 1; continue
        start = i
        block = []
        while i < len(lines) and lines[i].lstrip().startswith('|'):
            block.append(lines[i]); i += 1
        if len(block) < 2:
            continue
        if not SEP.match(block[1]):
            out.append(f"{path}:{start+2} 表の2行目が区切り行（|---|）ではない。GFM では表にならない")
            continue
        ncol = len(cells(block[0]))
        if ncol > MAX_COLS:
            out.append(f"{path}:{start+1} 表が {ncol} 列（上限 {MAX_COLS}）。転置・分割・節に分ける")
        for k, row in enumerate(block[2:], start=start+3):
            for c in cells(row):
                plain = re.sub(r'\[([^\]]*)\]\([^)]*\)', r'\1', c)  # リンクは表示テキストで数える
                if width(plain) > MAX_CELL_WIDTH:
                    out.append(f"{path}:{k} セルの表示幅 {width(plain)}（上限 {MAX_CELL_WIDTH}）: {plain[:12]}…")
                amb = sorted({ch for ch in plain if unicodedata.east_asian_width(ch) == 'A' and not ch.isalnum()})
                if amb:
                    out.append(f"{path}:{k} セルに幅が環境で変わる記号 {' '.join(amb)}。語（あり/なし、可/不可）か ASCII にする")
    return out

if __name__ == '__main__':
    problems = [p for f in sys.argv[1:] for p in check(f)]
    print("\n".join(problems))
    sys.exit(1 if problems else 0)
