#!/bin/bash

basepath=$(cd $(dirname $0); pwd)

if [ ! -d ${HOME}/.zsh ];then mkdir ${HOME}/.zsh; fi

# zsh files
if [ ! -d ~/.zsh ]; then
  mkdir ~/.zsh
fi
ln -sf ${basepath}/.zshenv ${HOME}/.zshenv
ln -sf ${basepath}/.zsh/.zshrc ${HOME}/.zsh/.zshrc
ln -sf ${basepath}/.zsh/.zshenv ${HOME}/.zsh/.zshenv
ln -sf ${basepath}/.zsh/.zprofile ${HOME}/.zsh/.zprofile
ln -snf ${basepath}/.zsh/rc ${HOME}/.zsh/rc

# vim files
ln -sf ${basepath}/.vimrc ${HOME}/.vimrc
ln -sf ${basepath}/.viminfo ${HOME}/.viminfo
ln -snf ${basepath}/.vim ${HOME}/.vim
ln -snf ${basepath}/.volt ${HOME}/.volt
ln -sf ${basepath}/.dein.toml ${HOME}/.dein.toml
ln -sf ${basepath}/.dein_lazy.toml ${HOME}/.dein_lazy.toml

