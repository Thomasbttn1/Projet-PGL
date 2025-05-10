#!/bin/bash
# Scraper EUR/USD via FastForex avec clé API perso

#API_KEY="d9f9b7f68e-620d1636aa-sub8cr"
API_KEY="M25AKAQAPI4XT2MS"
OUTPUT_FILE="data2.csv"

cd /home/ubuntu/Projet-PGL
source venv/bin/activate

# Créer le fichier si besoin
if [ ! -f "$OUTPUT_FILE" ]; then
  echo "timestamp,eurusd" > "$OUTPUT_FILE"
fi

# Appel API FastForex
eurusd=$(curl -s "https://api.fastforex.io/fetch-one?from=EUR&to=USD&api_key=${API_KEY}" | jq -r '.result.USD')

# Timestamp
now=$(date +'%Y-%m-%d %H:%M:%S')

if [[ -z "$eurusd" || "$eurusd" == "null" ]]; then
  echo "$now,error" >> "$OUTPUT_FILE"
  echo "❌ Erreur : taux EUR/USD non trouvé"
else
  echo "$now,$eurusd" >> "$OUTPUT_FILE"
  echo "✅ EUR/USD scrappé : $eurusd"
fi
