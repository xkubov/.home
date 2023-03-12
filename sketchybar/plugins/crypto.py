#!/usr/bin/env python3

import requests
import os

response = requests.get('https://api.gemini.com/v1/pricefeed')
json_response = response.json()

for i in json_response:
    pair = i["pair"]
    if pair in ["BTCUSD", "ETHUSD"]:
        price = int(float(i["price"]))
        os.system(f"sketchybar -m --set {pair.lower()} label={price}$")
