#!/usr/bin/env python3
import dash
from dash import html, dcc
from dash.dependencies import Input, Output
import pandas as pd
import plotly.express as px

# Initialisation de l'application Dash
app = dash.Dash(__name__)
server = app.server  # Pour déploiement sur un hébergeur éventuel

def load_data():
    """
    Charge les données à partir du fichier CSV.
    Le fichier CSV doit contenir deux colonnes (sans en-tête) :
      - timestamp : date et heure d'enregistrement
      - price : prix scrappé
    """
    try:
        # Lecture du fichier CSV en attribuant des noms aux colonnes
        df = pd.read_csv('data.csv', names=['timestamp', 'price'])
        # Conversion de la colonne timestamp en datetime
        df['timestamp'] = pd.to_datetime(df['timestamp'])
        # Conversion de la colonne price en numérique
        df['price'] = pd.to_numeric(df['price'], errors='coerce')
        return df
    except Exception as e:
        print("Erreur lors du chargement des données :", e)
        return pd.DataFrame(columns=['timestamp', 'price'])

# Définition du layout de l'application
app.layout = html.Div([
    html.H1("Dashboard - Prix Apple"),
    html.Div(id='current-info', style={'fontSize': '24px', 'marginBottom': '20px'}),
    dcc.Graph(id='time-series'),
    # Intervalle pour rafraîchir le dashboard toutes les 5 minutes (5*60*1000 millisecondes)
    dcc.Interval(id='interval-component', interval=5*60*1000, n_intervals=0)
])

# Callback pour mettre à jour l'information actuelle et le graphique
@app.callback(
    [Output('current-info', 'children'),
     Output('time-series', 'figure')],
    [Input('interval-component', 'n_intervals')]
)
def update_dashboard(n):
    df = load_data()
    if df.empty:
        current_info = "Aucune donnée disponible"
        fig = {}
    else:
        # On récupère la dernière entrée pour afficher le prix actuel
        latest = df.iloc[-1]
        current_info = f"Prix actuel : ${latest['price']} à {latest['timestamp'].strftime('%Y-%m-%d %H:%M:%S')}"
        # Création du graphique avec Plotly Express
        fig = px.line(df, x='timestamp', y='price', title="Évolution du prix Apple")
    return current_info, fig

if __name__ == '__main__':
    # Démarrage du serveur Dash (accessible sur http://localhost:8050)
    # Pour une utilisation en production, pensez à passer debug=False
    app.run_server(debug=True, host='0.0.0.0')
