#!/bin/bash

disk=(
	label.font="$FONT:Heavy:13"
	icon.font="Hack Nerd Font:Bold:20.0"
	icon="$DISK"
	update_freq=60
	script="$PLUGIN_DIR/disk.sh"
	label.padding_right=13
	icon.padding_left=13
)

sketchybar --add item usage.disk e \
	--set usage.disk "${disk[@]}"

memory=(label.font="$FONT:Heavy:13"
	icon.font="Hack Nerd Font:Bold:24.0"
	icon="$MEMORY"
	update_freq=15
	script="$PLUGIN_DIR/ram.sh"
	label.padding_right=13
)

sketchybar --add item usage.ram e \
	--set usage.ram "${memory[@]}"

cpu_percent=(
	label.font="$FONT:Heavy:13"
	icon.font="Hack Nerd Font:Bold:18.0"
	label=CPU
	update_freq=4
	mach_helper="$HELPER"
	label.padding_right=13
	icon="$CPU"
)

sketchybar --add item cpu.percent e \
	--set cpu.percent "${cpu_percent[@]}"

status_bracket=(
	background.color=$BACKGROUND_1
	background.border_color=$BACKGROUND_2
	background.border_width=2
)

sketchybar --add bracket usage_bracket usage.ram usage.disk cpu.percent \
	--set usage_bracket "${status_bracket[@]}"
