#!/usr/bin/env bash

sketchybar -m --set usage.disk label="$(df -H | grep -E '^(/dev/disk3s5).' | awk '{ printf ("%s\n", $5) }')"
