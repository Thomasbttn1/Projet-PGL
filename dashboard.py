#!/usr/bin/env python3
import dash
from dash import html, dcc
from dash.dependencies import Input, Output
import pandas as pd
import plotly.express as px
 
# Initialisation de l'application Dash
app = dash.Dash(__name__)
server = app.server  # Pour déploiement éventuel
 
def load_data():
    """
    Charge les données à partir du fichier CSV.
    Le fichier CSV doit contenir deux colonnes (sans en-tête) :
      - timestamp : date et heure d'enregistrement
      - price : prix scrappé
    """
    try:
        df = pd.read_csv('data.csv', names=['timestamp', 'price'])
        df['timestamp'] = pd.to_datetime(df['timestamp'])
        df['price'] = pd.to_numeric(df['price'], errors='coerce')
        return df
    except Exception as e:
        print("Erreur lors du chargement des données :", e)
        return pd.DataFrame(columns=['timestamp', 'price'])
 
def load_daily_report():
    """
    Charge le rapport quotidien à partir du fichier daily_report.txt.
    Ce fichier doit être mis à jour quotidiennement (par exemple via cron à 20h).
    """
    try:
        with open('daily_report.txt', 'r') as f:
            report = f.read()
    except Exception as e:
        report = "Daily report non disponible."
    return report
 
# Définition du layout de l'application
app.layout = html.Div([
    html.H1("Dashboard - Prix Apple"),
    html.Div(id='current-info', style={'fontSize': '24px', 'marginBottom': '20px'}),
    dcc.Graph(id='time-series'),
    html.H2("Rapport Quotidien"),
    html.Pre(id='daily-report', style={'backgroundColor': '#f4f4f4', 'padding': '10px'}),
    # Intervalle pour rafraîchir le dashboard toutes les 5 minutes (5*60*1000 ms)
    dcc.Interval(id='interval-component', interval=5*60*1000, n_intervals=0)
])
 
# Callback pour mettre à jour l'information, le graphique et le rapport quotidien
@app.callback(
    [Output('current-info', 'children'),
     Output('time-series', 'figure'),
     Output('daily-report', 'children')],
    [Input('interval-component', 'n_intervals')]
)
def update_dashboard(n):
    # Mise à jour du prix et du graphique
    df = load_data()
    if df.empty:
        current_info = "Aucune donnée disponible"
        fig = {}
    else:
        latest = df.iloc[-1]
        current_info = f"Prix actuel : ${latest['price']} à {latest['timestamp'].strftime('%Y-%m-%d %H:%M:%S')}"
        fig = px.line(df, x='timestamp', y='price', title="Évolution du prix Apple")
   
    # Lecture du rapport quotidien
    daily_report = load_daily_report()
   
    return current_info, fig, daily_report
 
if __name__ == '__main__':
    # Pour la production, passez debug=False
    app.run_server(debug=True, host='0.0.0.0')
