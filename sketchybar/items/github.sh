#!/bin/bash

POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

github_bell=(
	update_freq=180
	icon.font="$FONT:Bold:15.0"
	icon=$BELL
	label=$LOADING
	popup.align=right
	script="$PLUGIN_DIR/github.sh"
	click_script="$POPUP_CLICK_SCRIPT"
	background.color=$BACKGROUND_1
	background.border_color=$BACKGROUND_2
	background.border_width=2
	icon.padding_left=13
	label.padding_right=13
	padding_left=26
	padding_right=26
)

github_template=(
	drawing=off
	background.corner_radius=12
	icon.background.height=2
	icon.background.y_offset=-12
	background.color=$BACKGROUND_1
	background.border_color=$BACKGROUND_2
	background.border_width=2
)

sketchybar --add item github.bell q \
	--set github.bell "${github_bell[@]}" \
	--subscribe github.bell mouse.entered \
	mouse.exited \
	mouse.exited.global \
	\
	--add item github.template popup.github.bell \
	--set github.template "${github_template[@]}"
