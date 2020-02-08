export LC_ALL=ja_JP.UTF-8
export LANG=ja_JP.UTF-8

# direnv
export EDITOR="vim"

# ls colors
export CLICOLOR=1;
export LSCOLORS=gxfxcxdxbxegedabagacad;
export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:"

# enchancd
export ENHANCD_FILTER=fzf:peco:percol:gof

# Homebrew
export PATH=/usr/local/bin:$PATH

# golang
export GOPATH=$HOME/go
export GOROOT=$(go env GOROOT)
export PATH=$GOPATH/bin:$PATH

#python
export PYENV_ROOT=$HOME/.pyenv
export PATH=$HOME/.pyenv/bin:$PATH
command -v pyenv > /dev/null && eval "$(pyenv init -)"

if [ -n "$DEBUG" ]; then
	zmodload zsh/zprof && zprof
	unset DEBUG
fi

#ruby
export PATH=/usr/local/opt/ruby/bin:$PATH

