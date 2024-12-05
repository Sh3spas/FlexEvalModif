import os
import re
import json
import pandas as pd

# Fonction pour déterminer le system_name à partir du fichier JSON
def extract_system_name_from_json(filename, json_data):
    for key, value in json_data.items():
        systems = value.get("systems", [])
        for system in systems:
            if system["data"].lower() == filename.lower():
                return system["name"]
    return "unknown"

# Fonction principale pour lire tous les CSV et créer un CSV combiné
def combine_csv_files(input_folder, output_file, json_file):
    combined_data = []

    # Charger les données du fichier JSON
    with open(json_file, 'r') as f:
        json_data = json.load(f)

    # Parcourir tous les fichiers dans le dossier d'entrée
    for filename in os.listdir(input_folder):
        if filename.endswith(".csv"):
            filepath = os.path.join(input_folder, filename)

            # Lire le CSV actuel
            df = pd.read_csv(filepath)

            # Extraire le context et le system_name à partir du fichier JSON
            context = os.path.splitext(filename)[0]
            system_name = extract_system_name_from_json(filename, json_data)

            # Ajouter les colonnes 'context' et 'system_name' au DataFrame
            df['context'] = context
            df['system_name'] = system_name

            # Ajouter les colonnes dans l'ordre souhaité
            df = df[['context', 'system_name', 'assets']]
            df.rename(columns={'assets': 'asset'}, inplace=True)

            # Ajouter les données combinées à la liste
            combined_data.append(df)

    # Concaténer tous les DataFrames pour créer un CSV combiné
    if combined_data:
        combined_df = pd.concat(combined_data, ignore_index=True)
        combined_df.to_csv(output_file, index=False)
        print(f"CSV combiné créé avec succès : {output_file}")
    else:
        print("Aucun fichier CSV trouvé dans le dossier.")

# Spécifiez le dossier d'entrée, le fichier de sortie, et le fichier JSON
input_folder = "./systems"
output_file = "./systems/all_systems.csv"
json_file = "tests.json"

combine_csv_files(input_folder, output_file, json_file)
