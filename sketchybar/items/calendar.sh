#!/bin/bash

calendar=(
	icon=cal
	icon.font="$FONT:Black:14.0"
	label.width=45
	label.align=right
	padding_left=5
	update_freq=30
	script="$PLUGIN_DIR/calendar.sh"
	click_script="$PLUGIN_DIR/zen.sh"
	icon.padding_left=15
	icon.padding_right=15
	label.padding_right=15
	background.color=$BACKGROUND_1
	background.border_color=$BACKGROUND_2
	background.border_width=2
)

sketchybar --add item calendar right \
	--set calendar "${calendar[@]}" \
	--subscribe calendar system_woke
