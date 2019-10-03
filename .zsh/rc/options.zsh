# General
setopt correct           # Correct command mistake
setopt no_flow_control   # Disable lock with CTL+S and CTL+q

# History options
setopt share_history     # share history with other terminal
setopt histignorealldups # Delete an old recorded event if a new event is a duplicate
setopt histignorespace   # Do not record an event start with a space
setopt histsavenodups    # Do not write a duplicate event to the history file

# Directory options
setopt pushdignoredups   # Do not store duplicates in the stack
setopt pushdsilent       # Do not print the direcotry stack after pushd on popd
setopt extendedglob      # Use extended globbing syntax
