# General
setopt correct           # Correct command mistake
setopt no_flow_control   # Disable lock with CTL+S and CTL+q
setopt no_global_rcs

# Use emacs keybindings (even with EDITOR=nvim)
bindkey -e

# History options
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=16384
SAVEHIST=16384
setopt bang_hist
setopt extended_history
setopt inc_append_history
setopt hist_reduce_blanks
setopt magic_equal_subst
setopt hist_expand
setopt share_history     
setopt histignorealldups 
setopt histignorespace   
setopt histsavenodups    

# Directory options
setopt pushdignoredups   # Do not store duplicates in the stack
setopt pushdsilent       # Do not print the direcotry stack after pushd on popd
setopt extendedglob      # Use extended globbing syntax
