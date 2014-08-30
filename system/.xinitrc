#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

#自定义设置
export LANG=zh_CN.UTF-8
export LC_ALL="zh_CN.UTF-8"


export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE="fcitx"

#export LESSCHARSET=utf-8

XIM=fcitx
XIM_PROGRAM=fcitx
XMODIFIERS=@im=fcitx

fcitx&

#开启窗体透明模式
xcompmgr -C &

# exec gnome-session
# exec startkde
# exec startxfce4
exec awesome  #启动窗口管理器
# ...or the Window Manager of your choice
