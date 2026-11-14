# ~/.zshrc — 対話シェル用
# 方針: oh-my-zsh なし / ランタイムは mise だけ / マシン固有の設定は ~/.zshrc.local

# --- history ---------------------------------------------------------------
HISTFILE="$HOME/.zhistory"
HISTSIZE=100000
SAVEHIST=100000
setopt share_history hist_ignore_dups hist_ignore_space hist_expire_dups_first hist_verify hist_reduce_blanks

# --- options ---------------------------------------------------------------
setopt auto_cd interactive_comments no_beep

# --- completion ------------------------------------------------------------
fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
autoload -Uz compinit
mkdir -p "$XDG_CACHE_HOME/zsh"
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select

# --- tools -----------------------------------------------------------------
eval "$(mise activate zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)   # Ctrl-T / Ctrl-R(履歴検索) / Alt-C

# --- fzf -------------------------------------------------------------------
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_compgen_path() { fd --hidden --exclude .git . "$1"; }
_fzf_compgen_dir()  { fd --type=d --hidden --exclude .git . "$1"; }

_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'" "$@" ;;
    ssh)          fzf --preview 'dig {}' "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# fzf テーマ（WezTerm の配色に合わせる）
() {
  local fg="#CBE0F0" bg="#011628" bg_hl="#143652" purple="#B388FF" blue="#06BCE4" cyan="#2CF9ED"
  export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_hl},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
}

source "$XDG_CONFIG_HOME/zsh/fzf-git.sh"   # Ctrl-G 系の git ピッカー

export BAT_THEME=tokyonight_night

# --- aliases ---------------------------------------------------------------
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ll="eza --long --git --icons=always --all"
alias cat="bat"
alias cd="z"
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias lg="lazygit"

# --- yazi: 終了時のディレクトリに移動する ----------------------------------
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# --- マシン固有・秘密（Git 管理外） -----------------------------------------
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# --- plugins（syntax-highlighting は必ず最後） ------------------------------
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
