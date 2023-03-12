#!/bin/bash
#
btc_logo=(
	icon=$BITCOIN
	icon.font="$FONT:Black:20.0"
	icon.padding_right=7
	label.padding_right=13
	icon.y_offset=1
	label=BTC
	icon.color=$ORANGE
	background.border_width=2
	align=center
	script="~/.config/sketchybar/plugins/crypto.py"
)

eth_logo=(
	icon=$ETHEREUM
	icon.font="Hack Nerd Font:Black:20.0"
	icon.padding_left=13
	icon.padding_right=7
	label.padding_right=13
	icon.y_offset=1
	label=BTC
	icon.color=$MAGENTA
	background.border_width=2
	align=center
	script="~/.config/sketchybar/plugins/crypto.py"
)

sketchybar --add item btcusd q \
	--set btcusd "${btc_logo[@]}"

sketchybar --add item ethusd q \
	--set ethusd "${eth_logo[@]}"

status_bracket=(
	background.color=$BACKGROUND_1
	background.border_color=$BACKGROUND_2
	background.border_width=2
)

sketchybar --add bracket crypto_bracket btcusd ethusd \
	--set crypto_bracket "${status_bracket[@]}"
