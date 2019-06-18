source .bash_src/ps1.bash
source .bash_src/ls.bash
source .bash_src/aliases.bash
source .bash_src/editors.bash
[ -f .bashrc_local ] && source .bashrc_local
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f "/usr/local/etc/profile.d/bash_completion.sh" ] && . "/usr/local/etc/profile.d/bash_completion.sh"

export PATH="$HOME/.scripts:$HOME/install/bin:${PATH}"

default_ps1
