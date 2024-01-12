#!/bin/bash

sketchybar --add item kubectx right \
           --set kubectx update_freq=2 \
                      icon=􀝞 \
                      script="$PLUGIN_DIR/kubectx.sh"
