#!/bin/bash
# Scrape EUR/USD via exchangerate.host (clé API inutile)

OUTPUT_FILE="data2.csv"
cd /home/ubuntu/Projet-PGL
source venv/bin/activate

# Créer le fichier s’il n’existe pas
if [ ! -f "$OUTPUT_FILE" ]; then
  echo "timestamp,eurusd" > "$OUTPUT_FILE"
fi

# Appel API (sans clé)
JSON=$(curl -s "https://api.exchangerate.host/latest?base=EUR&symbols=USD")

# Extraction du taux via jq
eurusd=$(echo "$JSON" | jq -r '.rates.USD')

# Timestamp actuel
now=$(date +'%Y-%m-%d %H:%M:%S')

# Vérification de la validité du taux
if [[ -z "$eurusd" || "$eurusd" == "null" ]]; then
  echo "$now,error" >> "$OUTPUT_FILE"
  echo "❌ Erreur : taux EUR/USD non trouvé"
else
  echo "$now,$eurusd" >> "$OUTPUT_FILE"
  echo "✅ EUR/USD scrappé : $eurusd"
fi
