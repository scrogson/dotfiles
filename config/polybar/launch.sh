#!/usr/bin/env sh

# Terminate any already running bar instances
killall -q polybar

polybar top &

echo "Bars launched..."
