#!/bin/bash

basepath=$(cd $(dirname $0); pwd)

# zsh files
if [ ! -d ${HOME}/.zsh ];then mkdir ${HOME}/.zsh; fi
ln -sf ${basepath}/.zshenv ${HOME}/.zshenv
ln -sf ${basepath}/.zsh/.zshrc ${HOME}/.zsh/.zshrc
ln -sf ${basepath}/.zsh/.zshenv ${HOME}/.zsh/.zshenv
ln -sf ${basepath}/.zsh/.zprofile ${HOME}/.zsh/.zprofile
ln -snf ${basepath}/.zsh/rc ${HOME}/.zsh/rc

# vim files
ln -sf ${basepath}/.vimrc ${HOME}/.vimrc
ln -snf ${basepath}/.vim ${HOME}/.vim

if $CODESPACE; then
  sudo apt-get update && sudo apt-get install -y locales-all neovim tig
  sudo chsh "$(id -un)" --shell "/usr/bin/zsh"
  exit 0
fi

