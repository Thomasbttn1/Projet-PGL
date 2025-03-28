#!/bin/bash
# daily_report.sh : Génère un rapport quotidien à partir du fichier data2.csv (EUR/USD)

INPUT_FILE="data2.csv"
OUTPUT_FILE="daily_report.txt"
today=$(date +'%Y-%m-%d')

data=$(grep "^$today" "$INPUT_FILE")

if [ -z "$data" ]; then
    echo "Aucune donnée pour aujourd'hui ($today)" > "$OUTPUT_FILE"
    exit 0
fi

open=$(echo "$data" | head -n 1 | cut -d',' -f2)
close=$(echo "$data" | tail -n 1 | cut -d',' -f2)
max=$(echo "$data" | cut -d',' -f2 | sort -nr | head -n 1)
min=$(echo "$data" | cut -d',' -f2 | sort -n | head -n 1)
volatility=$(echo "$max - $min" | bc -l)
evolution=$(echo "scale=4; (($close - $open) / $open) * 100" | bc -l)

{
  echo "Rapport quotidien du $today - Taux EUR/USD"
  echo "--------------------------------------------"
  echo "Taux d'ouverture : $open"
  echo "Taux de clôture  : $close"
  echo "Taux maximum     : $max"
  echo "Taux minimum     : $min"
  echo "Volatilité       : $volatility"
  echo "Évolution        : $evolution %"
} > "$OUTPUT_FILE"

echo "Rapport quotidien généré dans $OUTPUT_FILE"
