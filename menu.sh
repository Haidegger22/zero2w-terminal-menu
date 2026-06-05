#!/bin/bash
W=60
CENTER_CMD() { local t="$1"; printf '%*s\n' $(( (W + ${#t}) / 2 )) "$t"; }

while true; do
    clear
    T=$(( $(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo 0) / 1000 ))
    printf '\033[1;48H\033[1;37m%s\033[0m' "$(date +%d.%m.%y)"
    printf '\033[2;43H\033[1;37m%s\033[0m  \033[1;33mCPU - %s°C\033[0m' "$(date +%H:%M)" "$T"
    printf '\033[5;1H'
    echo ''
    CENTER_CMD '===== Pi Zero 2W ====='
    echo ''
    printf '%60s\n' | tr ' ' '='

    mapfile -t items < /usr/local/etc/menu.conf 2>/dev/null
    total=${#items[@]}

    if [ $total -eq 0 ]; then
        echo ''
        echo '  No menu items. Add to /usr/local/etc/menu.conf'
        echo ''
    else
        echo ''
        half=$(( (total + 1) / 2 ))
        for ((i=0; i<half; i++)); do
            num1=$((i+1))
            name1=$(echo "${items[$i]}" | cut -d'|' -f1)
            line=$(printf '  %-2s) %-21s' "$num1" "$name1")
            j=$((i + half))
            if [ $j -lt $total ]; then
                num2=$((j+1))
                name2=$(echo "${items[$j]}" | cut -d'|' -f1)
                line+=$(printf '%2s) %-21s' "$num2" "$name2")
            fi
            echo "$line"
        done
    fi

    echo ''
    printf '%60s\n' | tr ' ' '='
    echo ''
    echo -n '> '
    read choice

    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] 2>/dev/null && [ "$choice" -le "$total" ] 2>/dev/null; then
        idx=$((choice - 1))
        cmd=$(echo "${items[$idx]}" | cut -d'|' -f2-)
        # Launch program, reset terminal on exit
        eval "$cmd" </dev/tty1 >/dev/tty1 2>/dev/tty1
        stty sane 2>/dev/null
    else
        echo "Enter 1-$total"
        sleep 1
    fi
done
