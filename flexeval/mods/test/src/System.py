# coding: utf8
import csv

from flask import current_app
from sqlalchemy import asc

from flexeval.utils import AppSingleton
from flexeval.database import db,commit_all

from flexeval.mods.test.model import SystemSample

class SystemError(Exception):

    def __init__(self, message):
        self.message = message

class SystemFileNotFound(SystemError):
    pass

class SystemManager(metaclass=AppSingleton):

    def __init__(self):
        self.register = {}

    def get(self, name, context):
        # Utilisation d'une clé combinant le nom du système et le contexte pour identifier chaque instance unique
        key = f"{name}:{context}"  
        if key not in self.register:
            # Ajout du contexte pour créer un système spécifique au contexte
            self.register[key] = System(name, context)
        return self.register[key]

class System():
    def __init__(self, name, context):
        if name[0] == "/":
            name = name[1:]

        self.name = name.strip()  # Suppression des espaces autour du nom du système
        self.context = context.strip()  # Stockage du contexte après suppression des espaces
        source_file = current_app.config["FLEXEVAL_INSTANCE_DIR"] + "/systems/all_systems.csv"

        try:
            with open(source_file, encoding='utf-8') as f:
                # Ajout d'un séparateur explicite (`,` au lieu de tabulation)
                reader = csv.DictReader(f, delimiter=',')  
                rows = list(reader)
                # Filtrage des lignes en fonction du nom du système et du contexte
                rows = [
                    row for row in rows
                    if row.get("system_name", "").strip() == self.name and row.get("context", "").strip() == self.context
                ]
        except Exception as e:
            # Lève une erreur spécifique si le fichier source est introuvable ou illisible
            raise SystemFileNotFound(f"{source_file} doesn't exist or is not readable. Error: {e}")

        if not rows:
            # Lève une erreur si aucune donnée ne correspond au nom et au contexte
            raise SystemError(f"No data found for system {self.name} with context {self.context} in {source_file}.")

        # Affichage des lignes chargées pour le débogage
        print(f"Rows loaded for {self.name} with context {self.context}: {rows}")  

        # Mise à jour des colonnes disponibles dans les données
        self.cols_name = list(rows[0].keys())

        # Suppression des échantillons existants pour ce système avant d'en ajouter de nouveaux
        SystemSample.query.filter(SystemSample.system == self.name).delete()
        commit_all()

        # Ajout des colonnes à la table SystemSample
        for col_name in self.cols_name:
            SystemSample.addColumn(col_name, db.String)
            print(f"Added column {col_name} to SystemSample.")  # Log pour confirmer l'ajout des colonnes

        # Si aucun échantillon n'existe encore, créer de nouveaux échantillons à partir des lignes
        if len(self.system_samples) == 0:
            for line_id, line in enumerate(rows):
                vars = {"system": self.name, "line_id": line_id}
                # Ajout des données de chaque colonne pour chaque ligne
                for col_name in self.cols_name:
                    vars[col_name] = line[col_name]
                SystemSample.create(commit=False, **vars)  # Création des échantillons sans commit immédiat
                print(f"Created SystemSample with values: {vars}")  # Log pour le débogage

            # Confirmation des modifications dans la base de données
            commit_all()

    @property
    def system_samples(self):
        # Retourne les échantillons existants pour ce système triés par ID de ligne
        return SystemSample.query.filter(SystemSample.system == self.name).order_by(SystemSample.line_id.asc()).all()
