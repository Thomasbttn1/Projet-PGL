#!/bin/bash

response=$(curl -s "http://api.currencylayer.com/live?access_key=97f7a70ab5e00669fab149aadd6393c6&currencies=EUR")

# Extraire le taux USDEUR (ex: "USDEUR":0.9245)
usdeur=$(echo "$response" | grep -o '"USDEUR":[0-9\.]*' | sed 's/[^0-9\.]*//g')

# Inverser pour obtenir EUR/USD
eurusd=$(echo "scale=6; 1 / $usdeur" | bc -l)

echo "$eurusd"
