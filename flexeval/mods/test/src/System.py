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

    def get(self,name):
        if not(name in self.register):
            self.register[name] = System(name)

        return self.register[name]

class System():
    def __init__(self, name):
        if name[0] == "/":
            name = name[1:]

        self.name = name.strip()  # Remove extra spaces
        source_file = current_app.config["FLEXEVAL_INSTANCE_DIR"] + "/systems/all_systems.csv"

        try:
            with open(source_file, encoding='utf-8') as f:
                reader = csv.DictReader(f, delimiter='\t')  # Specify tab as delimiter
                print(f"Columns in CSV: {reader.fieldnames}")  # Debug log
                rows = [row for row in reader if row.get("system_name", "").strip() == self.name]
        except Exception as e:
            raise SystemFileNotFound(f"{source_file} doesn't exist or is not readable. Error: {e}")

        if not rows:
            raise SystemError(f"No data found for system {self.name} in {source_file}.")

        print(f"Rows loaded for {self.name}: {rows}")  # Debug log

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

            print(f"Final columns in SystemSample: {SystemSample.__table__.columns.keys()}")



            commit_all()
    


    @property
    def system_samples(self):
        return SystemSample.query.filter(SystemSample.system == self.name).order_by(SystemSample.line_id.asc()).all()
