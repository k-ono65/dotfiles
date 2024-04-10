export LC_ALL=ja_JP.UTF-8
export LANG=ja_JP.UTF-8
export XDG_CONFIG_HOME=~/.config

# ls colors
export CLICOLOR=1;
export LSCOLORS=gxfxcxdxbxegedabagacad;
export TERM=xterm-256color
export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:"

# enchancd
#export ENHANCD_FILTER=fzf:peco:percol:gof

# Homebrew
path=(
  /opt/homebrew/bin(N-/)
  /usr/local/bin(N-/)
  $path
)

# terraform
TFENV_ARCH=arm64

# golang
path=(
  /usr/local/go/bin(N-/)
  $path
)
if (( $+commands[go] )); then
  export GOPATH=$HOME/go
  export GOROOT=$(go env GOROOT)
  path=($GOPATH/bin $path)
fi

#node
if (( $+commands[nodenv] )); then
  path=($(nodenv root)/shims $path)
  eval "$(nodenv init -)"
fi

#python
if (( $+commands[pyenv] )); then
  path=($(pyenv root)/shims $path)
  #eval "$(SHELL=zsh pyenv init --path --no-rehash)"
  eval "$(SHELL=zsh pyenv init --path)"
fi

#ruby
if (( $+commands[rbenv] )); then
  path=($(rbenv root)/shims $path)
  eval "$(SHELL=zsh rbenv init - --norehash)"
fi
#export PATH=/usr/local/opt/ruby/bin:$PATH

#rust
#path=($HOME/.cargo/bin $path)

# mysql
path=(
  /usr/local/opt/mysql-client/bin(N-/)
  $path
)

# postgresql
path=(
  /usr/local/opt/libpq/bin(N-/)
  $path
)

# krew
path=(
  ${KREW_ROOT:-$HOME/.krew}/bin
  $path
)

if [[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]]; then
  source "$HOME/google-cloud-sdk/path.zsh.inc"
fi

if [[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]]; then
  source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

. "$HOME/.cargo/env"
