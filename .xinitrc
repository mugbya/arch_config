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

 export LANG=zh_CN.UTF-8
 export LC_ALL="zh_CN.UTF-8"


fcitx&


# exec gnome-session
# exec startkde
# exec startxfce4
exec awesome
# ...or the Window Manager of your choice
