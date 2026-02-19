export ZDOTDIR=${HOME}/.zsh
source $ZDOTDIR/.zshenv
[[ -f $ZDOTDIR/.zsh_secret ]] && source $ZDOTDIR/.zsh_secret
. "$HOME/.cargo/env"
