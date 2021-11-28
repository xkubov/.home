#!/usr/bin/env fish

set -x PATH $HOME/install/bin $HOME/.scripts $PATH

set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8

set -x PATH $PATH /Users/kubov/.fzf/bin
set -g theme_nerd_fonts yes
set -g theme_display_date no
set -g theme_color_scheme terminal
set -g theme_show_exit_status yes
set -g default_user kubov
set -g theme_display_user yes
set -g theme_display_vi yes
set -g theme_display_virtualenv yes
set -g theme_display_cmd_duration yes
set -g theme_title_display_process yes
set -g theme_display_hg yes
set -g theme_display_vagrant yes
set -x VIRTUAL_ENV_DISABLE_PROMPT yes

set -x LD_LIBRARY_PATH $HOME/install/lib/
set -x CXX /opt/gcc-8/bin/g++
set -x CC /opt/gcc-8/bin/gcc


abbr b 'build'
abbr bp 'build -p'
abbr bd 'build -d -b build-debug'
abbr bdp 'build -d -b build-debug -p'

# git
abbr g "git"
alias gi "git init && git aa && git ci"

# mkdir
abbr md "mkdir"

# ls
# TODO: pls, check lsd, pls
alias ls "exa"

abbr l "ls"
alias la  "ls -a"
alias ll  "ls -lh"
alias lsa "ls -a"

# open script
abbr o "open"
abbr oc "vim $HOME/.config/fish/config.fish"
abbr og "vim $HOME/.gitconfig"

# tmux
set -x TERM "xterm-256color"
alias t "tmux"
alias tmx "tmux"

abbr t "tmux"
abbr ta "tmux a"
abbr tl "tmux ls"

# vim
abbr v "vim"
abbr vo "vim -O"
abbr vd "vimdiff"

# Vagrant
abbr va "vagrant"
abbr vai "vagrant init"
abbr vau "vagrant up"
abbr vah "vagrant halt"

alias nosetests "python3 -m nose"

alias python 'python3'
alias py python
alias pip 'pip3'

alias today "date +%Y-%m-%d"
#!/usr/bin/env fish

# Set ls to colored output
set -x CLICOLOR 1
set -x LSCOLORS ExFxBxDxCxegedabagacad
set -x EDITOR vim
alias vim="nvim"


[ -f ~/.fzf/shell/key-bindings.fish ] && . ~/.fzf/shell/key-bindings.fish

set -x PATH $HOME/.scripts $PATH

set -x PATH $HOME/.local/bin $PATH
set -x LD_LIBRARY_PATH $HOME/.local/lib $LD_LIBRARY_PATH
set -x PKG_CONFIG_PATH $HOME/.local/lib/pkgconfig

set -x LC_ALL en_US.UTF-8    
set -x LANG en_US.UTF-8    

set fish_greeting

set -x PATH $PATH /Users/kubov/.fzf/bin
set -g theme_nerd_fonts yes
set -g theme_display_date no
set -g theme_color_scheme terminal
set -g theme_show_exit_status yes
set -g theme_display_user no
set -g theme_display_vi no
set -g theme_display_virtualenv yes
set -g theme_display_cmd_duration yes
set -g theme_title_display_process yes
set -g theme_display_hg yes
set -g theme_display_vagrant yes
set -x VIRTUAL_ENV_DISABLE_PROMPT yes
