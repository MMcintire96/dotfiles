#!/usr/bin/env bash
killall -q polybar

# Wait until the processes have been shut down

#while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    #MONITOR=$m polybar --config=/home/michael/.config/i3/polybar/config --reload mybar &
    if [ $m != 'DP-3' ]; then
        #MONITOR=$m polybar --config=/home/michael/.config/i3/polybar/config --reload dummyBar &
        MONITOR=$m polybar --config=/home/michael/.config/i3/polybar/config --reload mybar &
        #MONITOR=$m polybar --config=/home/michael/.config/i3/polybar/config --reload centerBar &
        #MONITOR=$m polybar --config=/home/michael/.config/i3/polybar/config --reload leftBar &
        #MONITOR=$m polybar --config=/home/michael/.config/i3/polybar/config --reload rightBar &
        #MONITOR=$m polybar --config=/home/michael/.config/i3/polybar/config --reload dummyBar &
    fi
done;
#polybar --config=/home/michael/.config/i3/polybar/config mybar &

echo "Bars launched..."
