#!/bin/bash
# scrap_alpha.sh : Récupérer le cours en temps réel de l'action AAPL via l'API Alpha Vantage

# Clé API et symbole
API_KEY="XH0MO0VNE0IFI2K1"
SYMBOL="AAPL"

# URL de l'API pour obtenir le "Global Quote" de l'action
URL="https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=${SYMBOL}&apikey=${API_KEY}"

# Récupération du contenu JSON
JSON=$(curl -s "$URL")

# Extraction du prix à partir du JSON
# On recherche la valeur associée à "05. price"
# price=$(echo "$JSON" | grep -Po '"05\. price":\s*"\K[0-9.]+')
price=$(echo "$JSON" | sed -n 's/.*"05\. price": *"\([0-9.]*\)".*/\1/p')

# Vérification de la présence du prix
if [ -z "$price" ]; then
  echo "$(date +'%Y-%m-%d %H:%M:%S'),error" >> data.csv
  echo "Prix introuvable"
else
  echo "$(date +'%Y-%m-%d %H:%M:%S'),$price" >> data.csv
  echo "Prix scrappé : $price"
fi
