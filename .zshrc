# oh-my-zsh path and load
export ZSH=/home/km/.oh-my-zsh

# load my custom zsh theme
ZSH_THEME="kmac"

# terminal history settings
HISTSIZE=10000
SAVEHIST=1000
HISTFILE=~/.zsh_history
HIST_STAMPS="mm/dd/yyyy"

# Plugins
# plugins found in ~/.oh-my-zsh/plugins/*)
# custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# note to self:  zsh-syntax-highlighting downloaded from
# github.com/zsh-users/zsh-syntax-highlighting
plugins=(git bundler zsh-syntax-highlighting)

# Set vim as default editor
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

# Ruby/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi &> /dev/null

# Aliases
alias xmm='xmodmap ~/config_files/.xmodmap_custom_mappings'
alias ls='ls --color=auto --group-directories-first'
alias l='ls --color=auto --group-directories-first'
alias ll='ls -al --color=auto --group-directories-first'
alias grep='grep --color=always'
alias 1920='xrandr --output Virtual-1 --mode 1920x1080'

alias 2560="
xrandr --newmode '2560x1080_60.00'  230.00  2560 2720 2992 3424 1080 1083 1093 1120 -hsync +vsync; 
xrandr --addmode Virtual-1 2560x1080_60.00 ; 
xrandr --output Virtual-1 --mode 2560x1080_60.00"

# i3 power management fns
alias logout='i3-msg exit'
alias suspend='lock && systemctl suspend'

# Custom Functions

## ref_clock
# toggles set-ntp true
# vm's often don't update clocks properly
# if suspended for any length of time
ref_clock () {
    systemctl restart systemd-timesyncd.service
}

## go
# quickly nav to a dir in home dir
go () {
    p=$(find /home/$(whoami)/ -type d -name "$1*" | head -1)
    cd "$p"
}

## Vim last
# quickly open latest version in a writing dir
 vl () {
    vim $(ls | tail -n 1)
}

# github-create
#create repos on github from the command line
#thanks to eli fatsi on viget.com
github-create() {

  invalid_credentials = 0
  echo "Make sure to check for pre-existing remotes!!!!"
  echo "Fn will fail otherwise, but you won't get an error -- sneaky"

  echo "Also make sure to set export token to env ... "

  repo_name=$1

  dir_name=`basename $(pwd)`

  if [ "$repo_name" = "" ]; then
  echo "Repo name (hit enter to use '$dir_name')?"
  read repo_name
  fi

  if [ "$repo_name" = "" ]; then
  repo_name=$dir_name
  fi

  echo "Repo name will be: $repo_name"

  username=`git config github.user`
  if [ "$username" = "" ]; then
  echo "Could not find username, run 'git config --global github.user <username>'"
  invalid_credentials=1
  fi
  echo "User name will be: $username"

  #use encrypted github_token in config file repo to set env param
  gpg -d ~/config_files/github_token.gpg 2>/dev/null | export GITHUB_TOKEN=$(sed -n 2p)
  token=$GITHUB_TOKEN
  echo "Token has been set"

  if [ "$token" = "" ]; then
  echo "Could not find token, run 'git config --global github.token <token>'"
  invalid_credentials=1
  fi

  if [ "$invalid_credentials" = "1" ]; then
  echo "Invalid credentials"
  return 1
  fi

  echo -n "Creating Github repository '$repo_name' ..."
  curl -u "$username:$token" https://api.github.com/user/repos -d '{"name":"'$repo_name'"}' > /dev/null 2>&1
  echo " done."

  echo -n "Pushing local code to remote ..."
  git remote add origin https://github.com/$username/$repo_name.git > /dev/null 2>&1
  git push -u origin master > /dev/null 2>&1

  export GITHUB_TOKEN=""
  echo "clearing env vars..."
  echo " done."
}


# bind ctrl j/k to search command history 
bindkey "^K" history-beginning-search-backward
bindkey "^J" history-beginning-search-forward
# same for vi mode
bindkey -M viins "^K" history-beginning-search-backward
bindkey -M viins "^J" history-beginning-search-forward


# various options for vi-mode
# shorten delay between mode switches
export KEYTIMEOUT=1

 precmd() { RPROMPT="" }
 function zle-line-init zle-keymap-select {
   VIM_normal_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
   VIM_insert_PROMPT="%{$fg_bold[cyan]%} [% INSERT]%  %{$reset_color%}"
   RPS1="${${KEYMAP/vicmd/$VIM_normal_PROMPT}/(main|viins)/$VIM_insert_PROMPT} $EPS1"
   zle reset-prompt
 }

# source theme after resetting prompt
source $ZSH/oh-my-zsh.sh

zle -N zle-line-init
zle -N zle-keymap-select

# make right prompt (NORMAL or INSERT tag) disappear after cmd executes
setopt transientrprompt

# bind to vi keys after everything else is loaded
bindkey -v
