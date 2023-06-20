#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar.log

polybar --reload main & disown

for monitor in $(polybar --list-monitors | tail --lines=+2 | cut --delimiter=":" --fields=1); do
    MONITOR=$monitor polybar --reload common & disown
done

echo "Bar(s) launched..."
