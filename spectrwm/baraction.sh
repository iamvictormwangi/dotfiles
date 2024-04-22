#!/bin/bash
# Example Bar Action Script for Linux.
# Requires: acpi, iostat, lm-sensors, aptitude.
# Tested on: Debian Buster(with newest spectrwm built from source), Debian Bullseye, Devuan Chimaera, Devuan Ceres
# This config can be found on github.com/linuxdabbler

hostname="${HOSTNAME:-${hostname:-$(hostname)}}"

##############################
#	    DISK
##############################

hdd() {
    echo "$(df -h /home | grep /dev/ | awk '{print $5}')"
}

##############################
#	    RAM
##############################

mem() {
    used="$(free | grep Mem: | awk '{print $3}')"
    total="$(free | grep Mem: | awk '{print $2}')"
    human="$(free -h | grep Mem: | awk '{print $3}' | sed s/i//g)"

    ram="$(( 200 * $used/$total - 100 * $used/$total ))% ($human) "

    echo "$ram"
}

##############################
#	    CPU
##############################

cpu() {
    read cpu a b c previdle rest < /proc/stat
    prevtotal=$((a+b+c+previdle))
    sleep 0.5
    read cpu a b c idle rest < /proc/stat
    total=$((a+b+c+idle))
    cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
    echo "$cpu%"
}

##############################
#	    VOLUME
##############################

vol() {
  echo "$(amixer get Master | grep -oE '[0-9]{1,3}%')"
}

mic() {
  echo "$(amixer get Capture | grep -oE '[0-9]{1,3}%' | head -n 1)"
}

mpd() {
  echo "$(mpc current | cut -c 1-20)"
}

temp() {
  echo "$(temperature)"
}

dateinfo() {
    echo "$(curr-time)"
}

SLEEP_SEC=2

while :; do
  echo " $(mpd) | cpu: $(cpu) | mem: $(mem) | disk: $(hdd) | vol: $(vol) $(mic) | $(temp) | $(dateinfo)"
    sleep $SLEEP_SEC
done
