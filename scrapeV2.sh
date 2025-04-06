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
 
# Extraire le taux
eurusd=$(echo "$JSON" | grep -o '"USD":[0-9\.]*' | sed 's/[^0-9\.]*//g')
 
# Vérifie si on a bien récupéré le taux
if [ -z "$eurusd" ]; then
  echo "$(date +'%Y-%m-%d %H:%M:%S'),error" >> "$OUTPUT_FILE"
  echo "❌ Erreur : EUR/USD introuvable"
else
  echo "$(date +'%Y-%m-%d %H:%M:%S'),$eurusd" >> "$OUTPUT_FILE"
  echo "✅ EUR/USD scrappé : $eurusd"
fi
  eurusd=$(echo "scale=6; 1 / $usdeur" | bc -l)
  echo "$(date +'%Y-%m-%d %H:%M:%S'),$eurusd" >> "$OUTPUT_FILE"
  echo "EUR/USD scrappé : $eurusd"
fi
