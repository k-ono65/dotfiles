for rcfile in $ZDOTDIR/rc/*; do [ -r ${rcfile} ] && source ${rcfile}; done

autoload -Uz cdr
autoload -Uz colors && colors
autoload -Uz compinit && compinit
zstyle ':completion:*:default' list-colors ${(s.:.)LSCOLORS}

# fzf zstyle ":anyframe:selector:" use fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!**/.git/*"'
export FZF_DEFAULT_OPTS="--height 40% --reverse --border=sharp --ansi --multi --color=light"
export FZF_ALT_C_OPTS="--select-1 --exit-0"
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
        ls -lAG
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
eval "$(anyenv init -)"

#direnv
eval "$(direnv hook zsh)"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
