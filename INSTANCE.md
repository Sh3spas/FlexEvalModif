# Instance #

FlexEval creates a flask application based on your settings, refered as "Instance".

Back to [README](README.md).

[TOC]

## Structure

The instance directory should have the following structure:

```shell
<instance_name>/
├── legal.json                  # defines the GCU and GDPR
├── structure.json              # defines website configuration
├── tests.json                  # defines tests configuration 
├── systems/                    
│   ├── files/                  # contains all test assets  
│   │   ├── <asset>             
│   │   ...
│   ├── <system_name>.csv       # lists assets used by the system
│   ...
├── templates/                  # OPTIONAL
│   ├── <custom_template.tpl>   # a custom template that can be referenced in structure.json
│   ...
```

Replace the `<placeholders>` in this example by your own data.

You can use the `examples/example_instance` directory as a template

## 1. Writing `tests.json`

This file contains the tests' configuration.

Use the `examples/example_instance/tests.json` file as a base and modify it to suit your needs.

Create a json object filled with your data following this structure:   

**\<instance>/tests.json**
```json
{
  "<test_name>" : {
    "systems": [
      {"name": "<system_name>", "data": "<csv_file_path>"},
      ...
    ]
  },
  ...
}
```

## 2. Writing `structure.json`

This file is used to define the structure of the website.

Use the `examples/example_instance/structure.json` file as a base and modify it to suit your needs.

**IMPORTANT: stages of type "test" must have their name starting with the test type (ab, abx, mos, dmos, mushra)**

| Property                            | Type     | Required |
|-------------------------------------|----------|----------|
| [gdpr_compliance](#gdpr_compliance) | `string` | **Yes**  |
| [entrypoint](#entrypoint)           | `string` | **Yes**  |
| [variables](#variables)             | `object` | No       |
| [admin](#admin)                     | `object` | No       |
| [stages](#stages)                   | `object` | **Yes**  |

### gdpr_compliance

Two available values:

- `strict`: The server will start only if all the legal requirement are available.

- `relax`: The server will start even if all the legal requirement are not available.

More information about [legal compliance](LEGAL.md).

### entrypoint

The first page that any user will see.

The value of entrypoint need to be the name of one of the [stages](#stages).

### variables

All the keys defined in variables are available in any template.

`object` with following properties:

| Property      | Type   | Required |
|---------------|--------|----------|
| `title`       | string | No       | 
| `description` | string | No       | 
| `authors`     | string | No       | 
| *             | any    | No       |

### admin
The admin's field give you the possibility to setup your instance's admin panel.

The admin panel is composed of admin mods that you setup within this field.

If admin is not defined, you will get a 404 error if you try to acces your admin panel.

`object` with following properties:

| Property     | Type   | Required |
|--------------|--------|----------|
| `entrypoint` | object | **Yes**  |
| `mods`       | array  | **Yes**  |

**default admin panel:**
```json
"admin":{

  "entrypoint":{
    "mod":"admin_panel",
    "password":"<your password here>",
    "variables":{
      "subtitle":"Admin Panel"
    }
  },

  "mods": [
    {
      "mod":"export_bdd",
      "variables":{
        "subtitle":"Download Database",
        "subdescription":"Download the database in CSV or SQLite format."
      }
    },
    {
      "mod":"results_panel",
      "variables":{
        "subtitle":"Results panel",
        "subdescription":"View the results of your tests"
      }
    }
  ]

},
```

#### entrypoint
`entrypoint` contains a single `mod` object that will be the first page of your admin panel.
It should be `admin_panel` by default.

**default admin panel entrypoint:**
```json
"entrypoint":{
  "mod":"admin_panel",
  "password":"<your password here>",
  "variables":{
    "subtitle":"Admin Panel"
  }
},
```

#### mods

`mods` is an array of `mod` objects that you want to add to your admin panel.

the default admin panel is composed of the following mods:
- export_bdd
- results_panel

**default admin panel mods:**

```json
"mods": [
  {
    "mod":"export_bdd",
    "variables":{
      "subtitle":"Download Database",
      "subdescription":"Download the database in CSV or SQLite format."
    }
  },
  {
    "mod":"results_panel",
    "variables":{
      "subtitle":"Results panel",
      "subdescription":"View the results of your tests"
    }
  }
]
```

### stages

`stages` is an object that contains all the stages of your website.

Each stage is a page of your website.

Each property of this object corresponds to a stage.
The name of the property corresponds to the name assigned to the stage.

| Property     | Type   | Required     |
|--------------|--------|--------------|
| <stage_name> | object | At least one |

#### name
replace `<stage_name>` by the name of the stage.

**IMPORTANT: if the stage is of type `test`, the name must start with the test type (ab, abx, mos, dmos, mushra).**

#### object

> Note: object has different properties depending on the type of the stage.
> 
> Look at the examples below or at [examples/example_instance/structure.json](examples/example_instance/structure.json) for more information.

| Property                      | Type          | Required |
|-------------------------------|---------------|----------|
| `type`                        | string        | **Yes**  | 
| `next`                        | string/object | No       |
| *                             | any           | No       |

`type`'s value correspond to the name of one of the stage modules available.
More information about the [stage modules](MOD.md#STAGE).

`next`'s type can be either a `string` or an `object`:

- If next is a string
  - The property is the name of one of the stages, 
  - This stage will be display when the user trigger the action to go to the next stage.

- If next is an object
  - Each property is the name of a road.
  - The value associate to each property is the name of one of the stages.
  - Each road is link to one of the stages.

Example:

**structure.json:**
```json
"stages": {
  "intro":{
    ...
    "next":{"roadToMOS":"test_mos","roadToAB":"test_ab"}
  },
  "test_ab":  {... },
  "test_mos":  {... }
}
```

**someTemplate.tpl:**
```html
...
<a class="btn btn-primary" href="{{url_next['roadToAB']}}">AB Test</a>
<a class="btn btn-primary" href="{{url_next['roadToMOS']}}">MOS Test</a>
...
```

### Example

```json
{
  "gdpr_compliance":"relax",

  "entrypoint": "test_ab",

  "variables":{
    "title":"FlexEval",
    "authors":"Cédric Fayet"
  },

  "admin":{
    "entrypoint":{"mod":"admin_panel","password":"<your password>","variables":{"subtitle":"Admin Panel"}},
    "mods": [
      {"mod":"export_bdd","variables":{"subtitle":"Download Database","subdescription":"Download the database in CSV or SQLite format."}}
    ]
  },

  "stages": {
    "test_ab": {"type": "test", "template":"ab.tpl", "next":"test_mos","nb_steps":5, "nb_step_intro":2,  "transaction_timeout_seconds":600, "variables": {"subtitle":"Test AB"} },
    "fin_du_test": {"type": "page:user","template":"end.tpl"}
  }
}
```

## 3. Writing `legal.json` 

See [LEGAL.md](LEGAL.md).

## 4. Writing the `systems/<system_name>.csv` files 

This file lists which assets are used in the system. It starts by an "asset" column, followed by the path of the assets used in the system relative to <instance_path>/systems/files/

e.g.:

**\<instance>/systems/bird_sounds.csv**
```csv
asset
audio1.wav
audio2.wav
...
```

Remember to put the assets in the `systems/files/` directory.