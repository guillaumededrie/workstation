#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar.log
polybar main 2>&1 | tee -a /tmp/polybar-main.log & disown
polybar left 2>&1 | tee -a /tmp/polybar-left.log & disown
polybar middle 2>&1 | tee -a /tmp/polybar-left.log & disown
polybar right 2>&1 | tee -a /tmp/polybar-right.log & disown

echo "Bar(s) launched..."
