# Clone zplug if not exist
if [[ ! -d ~/.zplug ]]; then
	git clone https://github.com/zplug/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

# zsh plugins
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
#zplug "junegunn/fzf", from:gh-r, as:command, rename-to:fzf
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "mollifier/anyframe", lazy:true
zplug "b4b4r07/enhancd", use:"init.sh"

zplug "modules/utility", from:prezto
zplug "modules/completion", from:prezto
# Install uninstalled plugins
zplug check --verbose || zplug install
zplug load
