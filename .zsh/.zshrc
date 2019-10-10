for rcfile in $ZDOTDIR/rc/*; do [ -r ${rcfile} ] && source ${rcfile}; done

autoload -Uz cdr
autoload -Uz colors && colors
autoload -Uz compinit && compinit
zstyle ':completion:*:default' list-colors ${(s.:.)LSCOLORS}

# fzf
zstyle ":anyframe:selector:" use fzf
export FZF_DEFAULT_OPTS="--height 80% --border --ansi --multi"
export FZF_ALT_C_OPTS="--select-1 --exit-0"

# anyframe
autoload -Uz anyframe-init && anyframe-init

if (which zprof >/dev/null); then
	zprof | less -qR
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

chpwd() { 
    count=$(ls -lA | wc -l | bc)
    if [ ${count} -le 20 ]; then
        ls -lA
    fi
}

autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs
add-zsh-hook chpwd chpwd_recent_dirs

command -v pyenv > /dev/null && eval "$(pyenv init -)"

function buffer-fzf-history() {
    local HISTORY=$(history -n -r 1 | fzf +m)
    BUFFER=$HISTORY
    if [ -n "$HISTORY" ]; then
        CURSOR=$#BUFFER
    else
        zle accept-line
    fi
}
zle -N buffer-fzf-history
bindkey '^R' buffer-fzf-history
