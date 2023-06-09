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
#ln -sf ${basepath}/.vimrc ${HOME}/.config/nvim/init.vim
ln -snf ${basepath}/.vim ${HOME}/.vim

if $CODESPACE; then
  sudo apt-get update && sudo apt-get install -y locales-all tig bc fzf
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  ./nvim.appimage --appimage-extract
  sudo mv squashfs-root / && sudo ln -sf /squashfs-root/AppRun /usr/bin/nvim
  sudo chsh "$(id -un)" --shell "/usr/bin/zsh"
  exit 0
fi

