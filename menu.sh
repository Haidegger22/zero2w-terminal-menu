#!/bin/bash
W=60
center() { local t="$1"; printf '%*s\n' $(( (W + ${#t}) / 2 )) "$t"; }

while true; do
    clear
    T=$(( $(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo 0) / 1000 ))
    printf '\033[1;48H\033[1;37m%s\033[0m' "$(date +%d.%m.%y)"
    printf '\033[2;43H\033[1;37m%s\033[0m  \033[1;33mCPU - %s°C\033[0m' "$(date +%H:%M)" "$T"
    printf '\033[5;1H'
    echo ''
    center '===== Pi Zero 2W ====='
    echo ''
    printf '%60s\n' | tr ' ' '='
    echo ''
    printf '  %-28s %s\n' '1) Terminal'     '2) HTOP'
    printf '  %-28s %s\n' '3) Python'       '4) MC'
    printf '  %-28s %s\n' '5) Nano'         '6) Vim'
    printf '  %-28s %s\n' '7) System info'  '8) Reboot'
    printf '  %-28s %s\n' '9) Poweroff'
    echo ''
    printf '%60s\n' | tr ' ' '='
    echo ''
    echo -n '> '
    read choice
    case $choice in
        1) bash;; 2) htop;; 3) python3;; 4) mc;; 5) nano;; 6) vim;;
        7) bash -c 'echo; free -h; echo; uptime; echo; echo Press Enter...; read';;
        8) echo 2 | sudo -S reboot;;
        9) echo 2 | sudo -S poweroff;;
        *) echo 'Enter 1-9'; sleep 1;;
    esac
done
