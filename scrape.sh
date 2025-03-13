#!/bin/bash
# scrape.sh : Scraper le prix de l'action AAPL depuis Nasdaq
# URL de la page de l'action AAPL sur Nasdaq
URL="https://www.nasdaq.com/market-activity/stocks/aapl"

# Récupération du contenu HTML
HTML=$(curl -s "$URL")

# Extraction du prix à partir de la page HTML
# La regex utilisée ici est indicative et pourra être ajustée selon la structure actuelle du site
price=$(echo "$HTML" | grep -Po '(?<=<span class="symbol-page-header__pricing-price">\$)[0-9,]+\.[0-9]+')

# Retirer les éventuelles virgules pour obtenir un nombre correct
price=$(echo $price | tr -d ',')

if [ -z "$price" ]; then
  echo "$(date +'%Y-%m-%d %H:%M:%S'),error" >> data.csv
  echo "Prix introuvable"
else
  echo "$(date +'%Y-%m-%d %H:%M:%S'),$price" >> data.csv
  echo "Prix scrappé : $price"
fi
