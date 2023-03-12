#!/bin/bash

notch=(
	label.font="$FONT:Bold:15"
	icon.font="$FONT:Black:20.0"
	label="xxx"
	width=175
	icon.drawing=off
	background.color=$BACKGROUND_1
	background.border_color=$BACKGROUND_2
	background.border_width=2
)

sketchybar --add item notch center \
	--set notch "${notch[@]}"
