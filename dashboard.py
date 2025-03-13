import dash
from dash import html, dcc
from dash.dependencies import Input, Output
import pandas as pd
import plotly.express as px

# Initialisation de l'application Dash
app = dash.Dash(__name__)
server = app.server

def load_data():
    try:
        # Lecture du fichier CSV contenant les données scrappées
        df = pd.read_csv('data.csv', names=['timestamp', 'price'])
        # Conversion de la colonne timestamp en datetime
        df['timestamp'] = pd.to_datetime(df['timestamp'])
        # Exclusion des lignes où le scraping a échoué (marquées "error")
        df = df[df['price'] != 'error']
        df['price'] = pd.to_numeric(df['price'], errors='coerce')
        return df
    except Exception as e:
        print("Erreur lors du chargement des données :", e)
        return pd.DataFrame(columns=['timestamp', 'price'])

def load_daily_report():
    try:
        with open('daily_report.txt', 'r') as f:
            report = f.read()
    except Exception as e:
        report = "Rapport quotidien non disponible."
    return report

# Définition du layout de l'application
app.layout = html.Div([
    html.H1("Dashboard de Scraping - AAPL sur Nasdaq"),
    html.Div(id='current-price', style={'fontSize': 24, 'marginBottom': '20px'}),
    dcc.Graph(id='price-graph'),
    html.H2("Rapport Quotidien"),
    html.Pre(id='daily-report', style={'backgroundColor': '#f4f4f4', 'padding': '10px'}),
    dcc.Interval(
        id='interval-component',
        interval=5 * 60 * 1000,  # mise à jour toutes les 5 minutes
        n_intervals=0
    )
])

# Callback pour mettre à jour le dashboard en fonction du nombre d'intervalles écoulés
@app.callback(
    [Output('current-price', 'children'),
     Output('price-graph', 'figure'),
     Output('daily-report', 'children')],
    Input('interval-component', 'n_intervals')
)
def update_dashboard(n):
    df = load_data()
    if df.empty:
        current = "Aucune donnée disponible."
        fig = {}
    else:
        latest = df.iloc[-1]
        current = f"Prix actuel : ${latest['price']} à {latest['timestamp'].strftime('%Y-%m-%d %H:%M:%S')}"
        fig = px.line(df, x='timestamp', y='price', title='Historique des prix')
    report = load_daily_report()
    return current, fig, report

if __name__ == '__main__':
    app.run_server(debug=True, host='0.0.0.0')
