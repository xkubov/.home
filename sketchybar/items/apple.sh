#!/bin/bash

POPUP_OFF="sketchybar --set apple.logo popup.drawing=off"
POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

apple_logo=(
	icon=$APPLE
	icon.font="$FONT:Black:17.0"
	icon.color=$WHITE
	label.drawing=off
	click_script="$POPUP_CLICK_SCRIPT"
	popup.height=35
	icon.padding_left=13
	icon.padding_right=13
	background.color=$BACKGROUND_1
	background.border_color=$BACKGROUND_2
	background.border_width=2
	padding_right=5
	icon.y_offset=1
)

apple_prefs=(
	icon=$PREFERENCES
	label="Preferences"
	click_script="open -a 'System Preferences'; $POPUP_OFF"
)

apple_activity=(
	icon=$ACTIVITY
	label="Activity"
	click_script="open -a 'Activity Monitor'; $POPUP_OFF"
)

apple_lock=(
	icon=$LOCK
	label="Lock Screen"
	click_script="pmset displaysleepnow; $POPUP_OFF"
)

sketchybar --add item apple.logo left \
	--set apple.logo "${apple_logo[@]}" \
	\
	--add item apple.prefs popup.apple.logo \
	--set apple.prefs "${apple_prefs[@]}" \
	\
	--add item apple.activity popup.apple.logo \
	--set apple.activity "${apple_activity[@]}" \
	\
	--add item apple.lock popup.apple.logo \
	--set apple.lock "${apple_lock[@]}"
