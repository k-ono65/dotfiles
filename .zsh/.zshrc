# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
for rcfile in $ZDOTDIR/rc/*; do [ -r ${rcfile} ] && source ${rcfile}; done

autoload -Uz cdr
autoload -Uz colors && colors
# Docker CLI completions (compinit 前に fpath 追加)
fpath=($HOME/.docker/completions $fpath)

# compinit キャッシュ（24時間以上古い場合のみ再生成）
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zstyle ':completion:*:default' list-colors ${(s.:.)LSCOLORS}

# eza
alias ei="eza --icons --git"
alias ea="eza -la --icons --git"
alias ee="eza -aahl --icons --git"
alias et="eza -T -L 3 -a -I 'node_modules|.git|.cache' --icons"
alias eta="eza -T -a -I 'node_modules|.git|.cache' --color=always --icons | less -r"
alias ls=ei
alias la=ea
alias ll=ee
alias lt=et
alias lta=eta
alias l="clear && ls"


# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!**/.git/*"'
export FZF_DEFAULT_OPTS="--height 40% --reverse --border=sharp --ansi --multi --color=light"
export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=header,grid --line-range :100 {}"'
export FZF_ALT_C_OPTS="--preview 'eza {} -h -T -F  --no-user --no-time --no-filesize --no-permissions --long | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# anyframe
autoload -Uz anyframe-init && anyframe-init
zstyle ":anyframe:selector:" use fzf

if (which zprof >/dev/null); then
	zprof | less -qR
fi

chpwd() { 
    count=$(ls -lA | wc -l | bc)
    if [ ${count} -le 20 ]; then
        la
    fi
}

autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs
add-zsh-hook chpwd chpwd_recent_dirs

function fz() {
  INITIAL_QUERY=""
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
    fzf --bind "change:reload:$RG_PREFIX {q} || true" \
        --ansi --phony --query "$INITIAL_QUERY" \
        --preview 'cat `echo {} | cut -f 1 -d ":"`'
}

move_ghq_directories() {
  selected=`ghq list | fzf`
  if [ ${#selected} -gt 0 ]
  then
    target_dir="`ghq root`/$selected"
    echo "cd $target_dir"
    cd $target_dir
    zle accept-line
  fi
}
zle -N move_ghq_directories
bindkey "^]" move_ghq_directories

#anyenv
#if (( $+commands[anyenv] )); then
#  eval "$(anyenv init -)"
#fi

#direnv
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

# zoxide (enhancd から置き換え)
eval "$(zoxide init zsh --cmd cd)"

# cd .. でインタラクティブに親ディレクトリを選択
function __cd_parent_interactive() {
  local current_dir="${PWD}"
  local parent_dirs=()
  local dir="${current_dir}"

  while [[ "${dir}" != "/" ]]; do
    dir="$(dirname "${dir}")"
    parent_dirs+=("${dir}")
  done

  if [[ ${#parent_dirs[@]} -eq 0 ]]; then
    echo "Already at root directory"
    return 1
  fi

  local selected=$(printf '%s\n' "${parent_dirs[@]}" | fzf --height 40% --reverse --border=sharp --prompt="Select parent directory: ")

  if [[ -n "${selected}" ]]; then
    __zoxide_z "${selected}"
  fi
}

# zoxideのcd関数を保存してラップ
function cd() {
  if [[ "$1" == ".." && $# -eq 1 ]]; then
    __cd_parent_interactive
  else
    __zoxide_z "$@"
  fi
}

#fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


#. /opt/homebrew/opt/asdf/libexec/asdf.sh
eval "$(~/.local/bin/mise activate zsh)"

# claude alias (mise 管理の node から動的検出)
if command -v mise &>/dev/null; then
  _claude_path="$(mise where node 2>/dev/null)/bin/claude"
  [[ -x "$_claude_path" ]] && alias claude="$_claude_path"
  unset _claude_path
fi

# Docker CLI completions (fpath は上部の compinit で読み込み済み)

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
