####################
#### SETTINGS ######
####################

# Maybe shouldn't be setting this within shell rc, but if I don't, 
# tmux doesn't read dir_colors correctly for completion
export TERM=xterm-256color

# source other files
source ~/config_files/zsh/functions
source ~/config_files/zsh/styles
source ~/config_files/zsh/zsh_aliases

autoload -Uz compinit && compinit        # the completion engine
autoload -U colors && colors
autoload -Uz vcs_info
#

+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        hook_com[unstaged]+='%F{15}●'
    fi
}

# left prompt
PROMPT='%F{9}%n%F{15}@%F{13}%m%f %B%F{10}%1~%f %F{6}${vcs_info_msg_0_}%F{15} '

# these commands are run before each prompt refresh
precmd() { vcs_info RPROMPT="" }

# exports
export TERMINAL=/usr/bin/xterm
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim
export KEYTIMEOUT=1         # delay btwn mode switches
export GPG_TTY=$(tty)       # this is for neomutt
export bg_color="$(awk -F':' '/background/{gsub(" |\t",""); print $2}' ~/.Xresources)"

# setopts
setopt auto_pushd           # keep a stack of recent dirs
setopt complete_aliases     # autocomplete aliases
setopt pushd_ignore_dups    # ignore duplicate dirs
setopt extended_glob        # expand wildcards and suchlike
setopt transientrprompt     # transient right prompt
setopt prompt_subst         # allow string subs
setopt nocasematch          # case insensitive
setopt inc_append_history   # append history as you execute commands
setopt share_history        # share history between shells

# settings
DIRSTACKSIZE=20             # number to keep in dir stack
HISTSIZE=100000             # number of lines in working hist
SAVEHIST=100000             # numbre of lines in hist file
HISTFILE=~/.zsh_history     # where to save histfile
HIST_STAMPS="mm/dd/yyyy"    # timestamps for history / unused?

####################
####  BINDINGS  ####
####################

bindkey "^K" history-beginning-search-backward
bindkey "^J" history-beginning-search-forward
bindkey "^r" history-incremental-search-backward
bindkey -M viins "^K" history-beginning-search-backward
bindkey -M viins "^J" history-beginning-search-forward
bindkey -M viins "^U" backward-kill-line
bindkey -M vicmd "^U" backward-kill-line
bindkey -M viins "^A" beginning-of-line
bindkey -M vicmd "^A" beginning-of-line
bindkey -v                  # use vi mode

#  VI-mode tweaks
zle -N zle-line-init
zle -N zle-keymap-select

# source fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# resource dircolors...b/c tmux is not picking up LS_COLORS
eval "$(dircolors ~/config_files/dircolors)"

# deferred nvm loading - using bc default (above) was quite slow
# see https://github.com/creationix/nvm/issues/1277
# Defer initialization of nvm until nvm, node or a node-dependent command is
# run. Ensure this block is only run once if .bashrc gets sourced multiple times
# by checking whether __init_nvm is a function.

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
