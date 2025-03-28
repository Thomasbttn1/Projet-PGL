#!/bin/bash
# scrap_eurusd.sh : Scrape le taux EUR/USD depuis Currencylayer

API_KEY="97f7a70ab5e00669fab149aadd6393c6"
OUTPUT_FILE="data2.csv"
INTERVAL=60

# Création du fichier si inexistant
if [ ! -f "$OUTPUT_FILE" ]; then
  echo "timestamp,eurusd" > "$OUTPUT_FILE"
fi

while true; do
  # Appel API Currencylayer pour le taux EUR
  JSON=$(curl -s "http://api.currencylayer.com/live?access_key=${API_KEY}&currencies=EUR")

  # Extraction du taux USDEUR
  usdeur=$(echo "$JSON" | grep -o '"USDEUR":[0-9\.]*' | sed 's/[^0-9\.]*//g')

  # Vérification de la validité du taux
  if [ -z "$usdeur" ]; then
    echo "$(date +'%Y-%m-%d %H:%M:%S'),error" >> "$OUTPUT_FILE"
    echo "Erreur : USDEUR introuvable"
  else
    # Conversion en EUR/USD
    eurusd=$(echo "scale=6; 1 / $usdeur" | bc -l)
    echo "$(date +'%Y-%m-%d %H:%M:%S'),$eurusd" >> "$OUTPUT_FILE"
    echo "EUR/USD scrappé : $eurusd"
  fi

  sleep "$INTERVAL"
done
