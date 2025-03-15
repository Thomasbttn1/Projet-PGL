import dash
from dash import html, dcc
from dash.dependencies import Input, Output
import pandas as pd
import plotly.express as px

# Initialisation de l'application Dash
app = dash.Dash(__name__)
server = app.server  # Pour déploiement éventuel sur un hébergeur

def load_data():
    """
    Charge les données à partir du fichier CSV.
    Le fichier CSV est supposé avoir deux colonnes :
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

# Définition du layout de l'application
app.layout = html.Div([
    html.H1("Dashboard - Prix Apple"),
    html.Div(id='current-info', style={'fontSize': 24, 'marginBottom': '20px'}),
    dcc.Graph(id='time-series'),
    # Intervalle pour rafraîchir le dashboard toutes les 5 minutes (5*60*1000 ms)
    dcc.Interval(id='interval-component', interval=5*60*1000, n_intervals=0)
])

# Callback pour mettre à jour le contenu du dashboard
@app.callback(
    [Output('current-info', 'children'),
     Output('time-series', 'figure')],
    Input('interval-component', 'n_intervals')
)
def update_dashboard(n):
    df = load_data()
    if df.empty:
        # En cas d'absence de données
        current_info = "Aucune donnée disponible"
        fig = {}
    else:
        # On récupère la dernière donnée pour afficher le prix actuel
        latest = df.iloc[-1]
        current_info = f"Prix actuel : ${latest['price']} à {latest['timestamp'].strftime('%Y-%m-%d %H:%M:%S')}"
        # Création d'un graphique en ligne pour la série temporelle
        fig = px.line(df, x='timestamp', y='price', title="Évolution du prix Apple")
    return current_info, fig

if __name__ == '__main__':
    # Démarrage du serveur Dash (accessible par exemple à http://localhost:8050)
    app.run_server(debug=True, host='0.0.0.0')

