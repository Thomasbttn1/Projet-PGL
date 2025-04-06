#!/bin/bash
# Nouveau scraper EUR/USD via exchangerate.host

OUTPUT_FILE="data2.csv"
cd /home/ubuntu/Projet-PGL
source venv/bin/activate

# Créer le fichier si besoin
if [ ! -f "$OUTPUT_FILE" ]; then
  echo "timestamp,eurusd" > "$OUTPUT_FILE"
fi

# Appel API gratuite
JSON=$(curl -s "https://api.exchangerate.host/latest?base=EUR&symbols=USD")

# Extraire le taux proprement avec jq
eurusd=$(echo "$JSON" | grep -o '"USD":[0-9\.]*' | sed 's/[^0-9\.]*//g')

now=$(date +'%Y-%m-%d %H:%M:%S')

if [ -z "$eurusd" ]; then
  echo "$now,error" >> "$OUTPUT_FILE"
  echo "❌ Erreur : EUR/USD introuvable"
else
  echo "$now,$eurusd" >> "$OUTPUT_FILE"
  echo "✅ EUR/USD scrappé : $eurusd"
fi
