import csv

source_file = "/home/simon/Bureau/SAE/FlexEval/examples/example_instancee/systems/all_systems.csv"

with open(source_file, encoding='utf-8') as f:
    reader = csv.DictReader(f)
    print(f"Columns: {reader.fieldnames}")
    for row in reader:
        print(row)
