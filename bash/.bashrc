#!/bin/bash

source ${HOME}/.bashrc_conf/ps1
source ${HOME}/.bashrc_conf/aliases
source ${HOME}/.bashrc_conf/colors
source ${HOME}/.bashrc_conf/editors

[ -f .bashrc_local ] && source .bashrc_local
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PATH="$HOME/.scripts:$HOME/install/bin:${PATH}"

default_ps1

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
