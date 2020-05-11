#!/usr/bin/env bash
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --config=/home/michael/.config/i3/polybar/config --reload mybar &
done;
#polybar --config=/home/michael/.config/i3/polybar/config mybar &

echo "Bars launched..."
