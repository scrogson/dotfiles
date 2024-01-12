#!/bin/bash

CURRENT_CTX=$(kubectl config current-context | rev | cut -d'/' -f1 | rev | tr -d '\n' | cut -c1-4)

sketchybar --set kubectx label="$CURRENT_CTX"
