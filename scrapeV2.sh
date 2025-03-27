#!/bin/bash

# Appel API
response=$(curl -s https://api.dydx.exchange/v3/markets)

# Extraction du prix de BTC-USD avec grep et sed
price=$(echo "$response" | grep -o '"BTC-USD":{".*' | sed 's/.*"indexPrice":"\([^"]*\)".*/\1/')

# Affichage du prix
echo "$price"
