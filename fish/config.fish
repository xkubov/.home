source $HOME/.config/fish/.fish_conf/aliases    
source $HOME/.config/fish/.fish_conf/colors    
source $HOME/.config/fish/.fish_conf/editors    
source $HOME/.config/fish/.fishrc_local    

#[ -f .fishrc_local  ] && source .fishrc_local    
#[ -f ~/.fzf.fish  ] && source ~/.fzf.fish    

[ -f ~/.fzf/shell/key-bindings.fish ] && . ~/.fzf/shell/key-bindings.fish

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
