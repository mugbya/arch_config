#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then

    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then

    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#twm &
#xclock -geometry 50x50-1+1 &
#xterm -geometry 80x50+494+51 &
#xterm -geometry 80x20+494-0 &
#exec xterm -geometry 80x66+0+0 -name login


#自定义设置
export LANG=zh_CN.UTF-8
export LC_ALL="zh_CN.UTF-8"

#请安装fcixt fcitx-im fcitx-configtool 
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE="fcitx"

#export LESSCHARSET=utf-8

XIM=fcitx
XIM_PROGRAM=fcitx
XMODIFIERS=@im=fcitx

fcitx&

#开启窗体透明模式
xcompmgr -C&


# 开启声音
# pacman -S alsa-utils pulseaudio pamixer pavucontrol pulseaudio-alsa 
start-pulseaudio=x11


#exec awesome
exec startkde
