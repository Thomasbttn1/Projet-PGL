#!/bin/bash

response=$(curl -s https://api.dydx.exchange/v3/markets)

# On isole proprement le bloc "BTC-USD"
btc_block=$(echo "$response" | tr -d '\n' | grep -o '"BTC-USD":{[^}]*}')

# Ensuite on extrait "indexPrice" à l'intérieur de ce bloc
price=$(echo "$btc_block" | sed -n 's/.*"indexPrice":"\([^"]*\)".*/\1/p')

echo "$price"
