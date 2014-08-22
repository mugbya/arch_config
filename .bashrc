#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ "$TERM" == "xterm" ]; then
	export TERM=xterm-256color
fi


alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias ll='ls -l'
alias la='ls -al | less'
alias mm='sudo pacman -S'
alias mr='sudo pacman -Rs'
alias yy='sudo yaourt'
alias x='sudo startx'
alias wf='sudo wifi-menu wlp3s0'
alias py="python2.7 google/goagent/local/proxy.py"
alias jar='java -jar'

alias gst="git status"
alias gcm="git commit -m "
alias gb="git branch -a"
alias gck="git checkout "
alias gr="git checkout -f"
alias gp="git push origin "


#xcompmgr -c&
	
PATH=$PATH:/home/mugya/.gem/ruby/2.0.0/bin
export PATH

export PATH=$PATH:/home/mugya/android-linux_x86/sdk/tools/

export PATH=/tmp/yaourt-tmp-mugya/aur-sencha-cmd/pkg/sencha-cmd/opt/Sencha/Cmd/4.0.1.45:$PATH

export SENCHA_CMD_3_0_0="/tmp/yaourt-tmp-mugya/aur-sencha-cmd/pkg/sencha-cmd/opt/Sencha/Cmd/4.0.1.45"
