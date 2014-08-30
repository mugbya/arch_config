#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '


# my config 
alias ll='ls -l'
alias la='ls -al | less'
alias mm='sudo pacman -S'
alias mr='sudo pacman -Rs'
alias yy='sudo yaourt'
alias x='sudo startx'
alias wf='sudo wifi-menu wlp3s0'
#alias py="python2.7 google/goagent/local/proxy.py"
alias jar='java -jar'

alias gst="git status"
alias gcm="git commit -m "
alias gb="git branch -a"
alias gck="git checkout "
alias gr="git checkout -f"
alias gp="git push origin "
