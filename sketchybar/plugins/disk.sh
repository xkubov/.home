#!/usr/bin/env bash

sketchybar -m --set usage.disk label="$(df -H / | tail -1 | awk '{ printf ("%s\n", $5) }')"
