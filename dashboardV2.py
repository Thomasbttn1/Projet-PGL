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
    Charge les données EUR/USD à partir de 'data2.csv'.
    Le fichier doit contenir :
      - timestamp : date et heure
      - eurusd : taux EUR/USD scrappé
    """
    try:
        df = pd.read_csv('data2.csv', names=['timestamp', 'eurusd'], skiprows=1)
        df['timestamp'] = pd.to_datetime(df['timestamp'])
        df['eurusd'] = pd.to_numeric(df['eurusd'], errors='coerce')
        return df
    except Exception as e:
        print("Erreur lors du chargement des données :", e)
        return pd.DataFrame(columns=['timestamp', 'eurusd'])

def load_daily_report():
    """
    Charge le rapport quotidien depuis 'daily_report.txt'.
    """
    try:
        with open('daily_report.txt', 'r') as f:
            report = f.read()
    except Exception:
        report = "Daily report non disponible."
    return report

# Layout de l'application
app.layout = html.Div([
    html.H1("Dashboard - Taux EUR/USD"),
    html.Div(id='current-info', style={'fontSize': '24px', 'marginBottom': '20px'}),
    dcc.Graph(id='time-series'),
    html.H2("Rapport Quotidien"),
    html.Pre(id='daily-report', style={'backgroundColor': '#f4f4f4', 'padding': '10px'}),
    dcc.Interval(id='interval-component', interval=5*60*1000, n_intervals=0)  # rafraîchit toutes les 5 min
])

@app.callback(
    [Output('current-info', 'children'),
     Output('time-series', 'figure'),
     Output('daily-report', 'children')],
    [Input('interval-component', 'n_intervals')]
)
def update_dashboard(n):
    df = load_data()
    if df.empty:
        current_info = "Aucune donnée disponible"
        fig = {}
    else:
        latest = df.iloc[-1]
        current_info = f"Taux actuel EUR/USD : {latest['eurusd']} à {latest['timestamp'].strftime('%Y-%m-%d %H:%M:%S')}"
        fig = px.line(df, x='timestamp', y='eurusd', title="Évolution du taux EUR/USD")

    daily_report = load_daily_report()
    return current_info, fig, daily_report

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port = '8050')
