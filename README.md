# FlexEval #

FlexEval is an application that allows to design and deploy multimedia perceptual tests in the form of a light website. 

[TOC]

## Documentation

- [Instance](INSTANCE.md): Step by step guide to create an instance
- [Legal](LEGAL.md): Legal information generation
- [Template](TEMPLATE.md): Step by step guide to create a custom template
- [FAQ](FAQ.md)

## License

Licensed under the [CeCILL-C Free Software License Agreement](LICENSE).

## Installation

Installation requires:

- **python**: You may use versions from 3.6 to 3.11 [(Install here)](https://www.python.org/downloads/)
- **pip3**: The python package installer [(Install here)](](https://pypi.org/project/pip/))

Using a python virtual environment is reccomended as you will need to modify a library's code

1. Clone this git repository on your machine 
2. Open a terminal in the directory of the repository you just cloned
3. Install the necessary python libraries using these commands

```shell
pip3 install -r requirements.txt
pip3 install -U cachelib
```

4. Open `<path_of_your_python_environment>/lib/python<version>/site-packages/flask_session/sessions.py` in a text editor 
5. Change line 313 from ` from flask_caching.backends.filesystem import FileSystemCache` to `from cachelib import FileSystemCache`

## Creation of an instance

See [INSTANCE.md](INSTANCE.md).

## Launching the webserver

**Command:**

```shell
python3 run.py {absolute_instance_path}
```

**Options**:

| Short version | Long version | Description   | Default value    | Required |
|---------------|--------------|---------------|------------------|----------|
| `-h`          | `--help`     | Get help      |                  | No       |
| `-u`          | `--url`      | External URL  |                  | No       |
| `-i`          | `--ip`       | Server's IP   | http://127.0.0.1 | No       |
| `-p`          | `--port`     | Server's port | 8080             | No       |

**Example:**

from the FlexEval directory

```shell
python3 run.py ~/FlexEval/examples/example_instance
```

### Application Factory

Not satisfied with run.py ?
A FlexEval application is built using the application factory pattern. ([More information](https://flask.palletsprojects.com/en/1.1.x/patterns/appfactories/))

## Viewing results

**Note: you need the admin module to be enabled in your instance**

### Download DB

The results are stored in a SQLite database, which can be downloaded from the website as a zip file containing CSV files or as a SQLite file.

### Results panel

You can also go to the results panel, from which you can:

- View the results as tables (with pagination, filters, sorts, searching, etc...)
- Generate highly customisable graphs from the results
- Download the results in many formats


# How to cite

```bibtex
@inproceedings{fayet:hal-02768500,
  TITLE = {{FlexEval, cr{\'e}ation de sites web l{\'e}gers pour des campagnes de tests perceptifs multim{\'e}dias}},
  AUTHOR = {Fayet, C{\'e}dric and Blond, Alexis and Coulombel, Gr{\'e}goire and Simon, Claude and Lolive, Damien and Lecorv{\'e}, Gw{\'e}nol{\'e} and Chevelu, Jonathan and Le Maguer, S{\'e}bastien},
  URL = {https://hal.archives-ouvertes.fr/hal-02768500},
  BOOKTITLE = {{6e conf{\'e}rence conjointe Journ{\'e}es d'{\'E}tudes sur la Parole (JEP, 31e {\'e}dition), Traitement Automatique des Langues Naturelles (TALN, 27e {\'e}dition), Rencontre des {\'E}tudiants Chercheurs en Informatique pour le Traitement Automatique des Langues (R{\'E}CITAL, 22e {\'e}dition)}},
  ADDRESS = {Nancy, France},
  EDITOR = {Benzitoun, Christophe and Braud, Chlo{\'e} and Huber, Laurine and Langlois, David and Ouni, Slim and Pogodalla, Sylvain and Schneider, St{\'e}phane},
  PUBLISHER = {{ATALA}},
  PAGES = {22-25},
  YEAR = {2020}
}
```
