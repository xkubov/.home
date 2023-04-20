#!/usr/bin/env python3

import os

import requests

response = requests.get('https://api.gemini.com/v1/pricefeed')
json_response = response.json()

for i in json_response:
    pair = i["pair"]
    if pair in ["BTCUSD"]:
        price = round(1/(float(i["price"])/100000000), 2)
        os.system(f"sketchybar -m --set {pair.lower()} label='1$ = {price} sats'")
