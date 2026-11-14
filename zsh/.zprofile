# login シェルで 1 回だけ。PATH はここで組む。
# Homebrew は /opt/homebrew (ARM) の 1 系統だけ。/usr/local は使わない。
eval "$(/opt/homebrew/bin/brew shellenv)"

typeset -U path  # PATH の重複を自動で除く
path=(
  "$HOME/.local/bin"   # 自作スクリプト・uv tool
  "$HOME/.cargo/bin"   # rustup / cargo
  $path
)
export PATH
