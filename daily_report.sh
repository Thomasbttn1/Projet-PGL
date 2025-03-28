#!/bin/bash
# daily_report.sh : Génère un rapport quotidien à partir du fichier data2.csv (EUR/USD)

# Fichier source et fichier de sortie
INPUT_FILE="data2.csv"
OUTPUT_FILE="daily_report.txt"

# Récupérer la date du jour au format YYYY-MM-DD
today=$(date +'%Y-%m-%d')

# Extraire les lignes correspondant à aujourd'hui
data=$(grep "^$today" "$INPUT_FILE")

# Vérifier s'il y a des données
if [ -z "$data" ]; then
    echo "Aucune donnée pour aujourd'hui ($today)" > "$OUTPUT_FILE"
    exit 0
fi

# Prix d'ouverture (première valeur)
open=$(echo "$data" | head -n 1 | cut -d',' -f2)

# Prix de clôture (dernière valeur)
close=$(echo "$data" | tail -n 1 | cut -d',' -f2)

# Prix max
max=$(echo "$data" | cut -d',' -f2 | sort -nr | head -n 1)

# Prix min
min=$(echo "$data" | cut -d',' -f2 | sort -n | head -n 1)

# Volatilité (max - min)
volatility=$(echo "$max - $min" | bc -l)

# Evolution en %
evolution=$(echo "scale=4; (($close - $open) / $open) * 100" | bc -l)

# Écriture du rapport
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
