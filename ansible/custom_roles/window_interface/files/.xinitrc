#!/bin/bash

# invoke global X session script
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

feh --bg-fill $HOME/pictures/wallpaper
setxkbmap -option caps:escape

# initialize fcitx input method framework to enable mozc (japanese input metrod
# editor)
#export GTK_IM_MODULE=fcitx
#export QT_MI_MODULE=fcitx
#export XMODIFIERS=@im=fcitx
#
#fcitx &

Day() {
  printf `date "+%e" | sed -e 's/\ //'`

  case `date +%d` in
    1|21|31) printf "${day}st";;
    2|22)    printf "${day}nd";;
    3|23)    printf "${day}rd";;
    *)       printf "${day}th";;
  esac
}

Battery() {
  dir=/sys/class/power_supply/BAT0

  grep -q ^C "${dir}"/status && printf +
  cat "${dir}"/capacity
}

while true; do
  xsetroot -name "`date \"+%a, %b \`Day\` %k:%M\"`" # | Battery: `Battery`%"
  sleep 15
done &

exec dwm
