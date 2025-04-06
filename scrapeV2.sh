#!/bin/bash

OUTPUT_FILE="data2.csv"
cd /home/ubuntu/Projet-PGL
source venv/bin/activate

# Créer le fichier s’il n’existe pas
if [ ! -f "$OUTPUT_FILE" ]; then
  echo "timestamp,eurusd" > "$OUTPUT_FILE"
fi

# Appel API FastForex
eurusd=$(curl -s "https://api.fastforex.io/fetch-one?from=EUR&to=USD&api_key=demo" | jq -r '.result.USD')

# Timestamp
now=$(date +'%Y-%m-%d %H:%M:%S')

if [[ -z "$eurusd" || "$eurusd" == "null" ]]; then
  echo "$now,error" >> "$OUTPUT_FILE"
  echo "❌ Erreur : taux EUR/USD non trouvé"
else
  echo "$now,$eurusd" >> "$OUTPUT_FILE"
  echo "✅ EUR/USD scrappé : $eurusd"
fi
