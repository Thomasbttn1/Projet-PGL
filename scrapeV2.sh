#!/bin/bash
# Script pour récupérer le taux EUR/USD via FastForex API

API_KEY="a94d110a8f-47df5e67bd-sw1pb7"
OUTPUT_FILE="data2.csv"
URL="https://api.fastforex.io/fetch-one?from=EUR&to=USD&api_key=${API_KEY}"

cd /home/ubuntu/Projet-PGL || exit 1
source venv/bin/activate

# Création du fichier si inexistant
if [ ! -f "$OUTPUT_FILE" ]; then
  echo "timestamp,eurusd" > "$OUTPUT_FILE"
fi

# Appel de l'API
response=$(curl -s "$URL")
eurusd=$(echo "$response" | jq -r '.result.USD')
now=$(date +'%Y-%m-%d %H:%M:%S')

# Gestion des erreurs
if [[ -z "$eurusd" || "$eurusd" == "null" ]]; then
  echo "$now,error" >> "$OUTPUT_FILE"
  echo "❌ Erreur : taux EUR/USD non trouvé ou réponse invalide"
  echo "Réponse API : $response"
else
  echo "$now,$eurusd" >> "$OUTPUT_FILE"
  echo "✅ EUR/USD scrappé : $eurusd"
fi

