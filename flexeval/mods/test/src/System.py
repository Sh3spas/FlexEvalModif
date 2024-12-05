# coding: utf8
import csv

from flask import current_app
from sqlalchemy import asc

from flexeval.utils import AppSingleton
from flexeval.database import db,commit_all

from flexeval.mods.test.model import SystemSample

class SystemError(Exception):

    def __init__(self,message):
        self.message = message

class SystemFileNotFound(SystemError):
    pass


class SystemManager(metaclass=AppSingleton):

    def __init__(self):
        self.register={}

    def get(self, name, context):
        key = f"{name}:{context}"  # Use both name and context as the key
        if key not in self.register:
            self.register[key] = System(name, context)
        return self.register[key]


class System():
    def __init__(self, name, context):
        if name[0] == "/":
            name = name[1:]

        self.name = name.strip()  # Remove extra spaces
        self.context = context.strip()  # Store context
        source_file = current_app.config["FLEXEVAL_INSTANCE_DIR"] + "/systems/all_systems.csv"

        try:
            with open(source_file, encoding='utf-8') as f:
                reader = csv.DictReader(f, delimiter=',')  # Vérifiez le séparateur
                rows = list(reader)
                # Filtrage
                rows = [
                    row for row in rows
                    if row.get("system_name", "").strip() == self.name and row.get("context", "").strip() == self.context
                ]
        except Exception as e:
            raise SystemFileNotFound(f"{source_file} doesn't exist or is not readable. Error: {e}")

        if not rows:
            raise SystemError(f"No data found for system {self.name} with context {self.context} in {source_file}.")

        print(f"Rows loaded for {self.name} with context {self.context}: {rows}")  # Debug log

        self.cols_name = list(rows[0].keys())

        SystemSample.query.filter(SystemSample.system == self.name).delete()
        commit_all()

        for col_name in self.cols_name:
            SystemSample.addColumn(col_name, db.String)
            print(f"Added column {col_name} to SystemSample.")  # Debug log

        if len(self.system_samples) == 0:
            for line_id, line in enumerate(rows):
                vars = {"system": self.name, "line_id": line_id}
                for col_name in self.cols_name:
                    vars[col_name] = line[col_name]  # Include all columns
                SystemSample.create(commit=False, **vars)
                print(f"Created SystemSample with values: {vars}")  # Debug log

            commit_all()

    @property
    def system_samples(self):
        return SystemSample.query.filter(SystemSample.system == self.name).order_by(SystemSample.line_id.asc()).all()
