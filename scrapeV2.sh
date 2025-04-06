#!/bin/bash

API_KEY="7ebb645e5e2d654c494d427b4fea6870"
OUTPUT_FILE="data2.csv"

cd /home/ubuntu/Projet-PGL
source venv/bin/activate

# Créer le fichier s’il n’existe pas
if [ ! -f "$OUTPUT_FILE" ]; then
  echo "timestamp,eurusd" > "$OUTPUT_FILE"
fi

# Appel API avec la bonne clé
eurusd=$(curl -s "https://api.exchangerate.host/latest?base=EUR&symbols=USD&access_key=${API_KEY}" | jq -r '.rates.USD')

now=$(date +'%Y-%m-%d %H:%M:%S')

if [[ -z "$eurusd" || "$eurusd" == "null" ]]; then
  echo "$now,error" >> "$OUTPUT_FILE"
  echo "❌ Erreur : taux EUR/USD non trouvé"
else
  echo "$now,$eurusd" >> "$OUTPUT_FILE"
  echo "✅ EUR/USD scrappé : $eurusd"
fi
