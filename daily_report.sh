#!/bin/bash
# daily_report.sh : Génère un rapport quotidien à partir du fichier data.csv
 
# Récupérer la date du jour au format YYYY-MM-DD
today=$(date +'%Y-%m-%d')
 
# Extraire les lignes correspondant à aujourd'hui
data=$(grep "^$today" data.csv)
 
# Vérifier si des données existent pour aujourd'hui
if [ -z "$data" ]; then
    echo "Aucune donnée pour aujourd'hui ($today)" > daily_report.txt
    exit 0
fi
 
# Récupérer le premier enregistrement (prix d'ouverture)
open=$(echo "$data" | head -n 1 | cut -d',' -f2)
 
# Récupérer le dernier enregistrement (prix de clôture)
close=$(echo "$data" | tail -n 1 | cut -d',' -f2)
 
# Calculer le prix maximum et minimum de la journée
max=$(echo "$data" | cut -d',' -f2 | sort -nr | head -n 1)
min=$(echo "$data" | cut -d',' -f2 | sort -n | head -n 1)
 
# Calculer la volatilité (différence entre max et min)
volatility=$(echo "$max - $min" | bc -l)
 
# Calculer l'évolution en pourcentage : ((close - open)/open)*100
evolution=$(echo "scale=2; (($close - $open) / $open) * 100" | bc -l)
 
# Écrire le rapport dans daily_report.txt
{
  echo "Rapport quotidien du $today"
  echo "------------------------------"
  echo "Prix d'ouverture : $open"
  echo "Prix de clôture : $close"
  echo "Prix maximum : $max"
  echo "Prix minimum : $min"
  echo "Volatilité : $volatility"
  echo "Evolution : $evolution %"
} > daily_report.txt
 
echo "Rapport quotidien généré."
