# Accessing BigML.io from shell scripts

In this repository you'll find a set of very simple shell scripts
interacting with https://bigml.io/.

## Requirements

These shell scripts use bash, curl and python to interact with
https://bigml.io and create datasources, datasets, models and,
eventually, predictions.  You'll be also able to retrieve them in JSON
format.

The scripts are written in **bash**, and use **curl** to send HTTPS
requests to our servers.  Responses, in JSON format, are
pretty-printed in the console via python's **json.tool** module.

## Common setup

To access bigml.io you need a username and an API key, which are
assigned to you one you register in [our site](https://bigml.com).

The scripts look for them in the environment variables `BIGML_USERNAME`
and `BIGML_API_KEY`, which are combined in the authentication token
`BIGML_AUTH`.  The [env/api_key.sh](env/api_key.sh) file provides a
template you can use in your `.bashrc` or `.bash_profile` to set those
variables automatically when you log in:

```bash
BIGML_USERNAME=<username>
BIGML_API_KEY=<apikey>
export BIGML_URL=https://bigml.io/andromeda/
export BIGML_AUTH="username=$BIGML_USERNAME;api_key=$BIGML_API_KEY;"
```

All scripts in the repo live in the `bin` directory.

## Creating sources

To create a datasource from a local data file, use `create_source.sh`.
This simple script takes a single parameter, namely, the path to the
data file, and uses *curl* to upload the file to BigML's servers,
register an associated datasource and prints its JSON descriptor.

Here's a sample invocation:


```bash
~/bigml/io/bash $ ./create_source.sh ../csv/iris.csv
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  5461  100   653  100  4808    114    843  0:00:05  0:00:05 --:--:--  8094
{
    "code": 201,
    "content_type": "application/octet-stream",
    "created": "2012-03-23T01:44:25.687600",
    "credits": 0.0,
    "file_name": "iris.csv",
    "md5": "d1175c032e1042bec7f974c91e4a65ae",
    "name": "iris.csv",
    "number_of_datasets": 0,
    "number_of_models": 0,
    "number_of_predictions": 0,
    "private": true,
    "resource": "source/4f6bd5791552687fb5000003",
    "size": 4608,
    "source_parser": {
        "header": true,
        "locale": "en-US",
        "missing_tokens": [
            "N/A",
            "n/a",
            "NA",
            "na",
            "-",
            "?"
        ],
        "quote": "\"",
        "separator": ",",
        "trim": true
    },
    "status": {
        "code": 2,
        "elapsed": 0,
        "message": "The source creation has been started"
    },
    "type": 0,
    "updated": "2012-03-23T01:44:25.687628"
}
```


Resource creation is asynchronous: the created resource status code
will be, as you see in the sample above, 2 (i.e., *in-progress*).  You
can retrieve the descriptor (with its updated status) at any time
using the `get.sh` script with the **resource** identifier as its only
argument.

```bash
~/bigml/io/bash $ ./get.sh source/4f6bd5791552687fb5000003
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1050  100  1050    0     0    179      0  0:00:05  0:00:05 --:--:--  2908
{
    "code": 200,
    "content_type": "application/octet-stream",
    "created": "2012-03-23T01:44:25.687000",
    "credits": 0.0087890625,
    "fields": {
        "000000": {
            "column_number": 0,
            "name": "sepal length",
            "optype": "numeric"
        },
        "000001": {
            "column_number": 1,
            "name": "sepal width",
            "optype": "numeric"
        },
        "000002": {
            "column_number": 2,
            "name": "petal length",

[...]

    "status": {
        "code": 5,
        "elapsed": 2969,
        "message": "The source has been created"
    },
    "type": 0,
    "updated": "2012-03-23T01:44:28.755000"
}
```

## Creating datasets

Once you have created a datasource, you can create a *dataset*, which
is a processed version of the data accompanied by metadata describing
its contents (data types, histograms, etc.).

Creating a dataset containing all columns in the source and using the
default parsing options is accomplished via `create_dataset.sh`, which
takes the datasource resource identifier as its only argument.


```bash
~/bigml/io/bash $ ./create_dataset.sh source/4f6bd5791552687fb5000003
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   919  100   874  100    45    156      8  0:00:05  0:00:05 --:--:--  1758
{
    "code": 201,
    "columns": 5,
    "created": "2012-03-23T02:07:49.831948",
    "credits": 0.0087890625,
    "fields": {
        "000000": {
            "column_number": 0,
            "name": "sepal length",
            "optype": "numeric"
        },
        "000001": {
            "column_number": 1,
            "name": "sepal width",
            "optype": "numeric"
        },
        "000002": {
            "column_number": 2,
            "name": "petal length",
            "optype": "numeric"
        },
        "000003": {
            "column_number": 3,
            "name": "petal width",
            "optype": "numeric"
        },
        "000004": {
            "column_number": 4,
            "name": "species",
            "optype": "categorical"
        }
    },
    "locale": "en-US",
    "name": "iris' dataset",
    "number_of_models": 0,
    "number_of_predictions": 0,
    "private": true,
    "resource": "dataset/4f6bdaf51552687fb3000006",
    "rows": 0,
    "size": 4608,
    "source": "source/4f6bd5791552687fb5000003",
    "source_status": true,
    "status": {
        "code": 1,
        "message": "The dataset is being processed and will be created soon"
    },
    "updated": "2012-03-23T02:07:49.831969"
}
```

Again, the process is asynchronous: your task has been scheduled
(status 1, i.e., *queued*), and the new resource has been assigned an
identifier (*dataset/4f6bdaf51552687fb3000006*) which you can use in
conjunction with the `get.sh` script to recover the dataset's JSON
metadata at any other time:

```bash
./get.sh dataset/4f6bdaf51552687fb3000006
```

## Creating models

With a dataset resource in your hand, you can proceed to the creation
of a predictive model, using `create_model.sh`.

```bash
~/bigml/io/bash (master) $ ./create_model.sh dataset/4f6bdaf51552687fb3000006
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   691  100   644  100    47    112      8  0:00:05  0:00:05 --:--:--  1018
{
    "code": 201,
    "columns": 5,
    "created": "2012-03-23T02:28:57.741150",
    "credits": 0.03515625,
    "dataset": "dataset/4f6bdaf51552687fb3000006",
    "dataset_status": true,
    "holdout": 0.0,
    "input_fields": [],
    "locale": "en-US",
    "max_columns": 5,
    "max_rows": 150,
    "name": "iris' dataset model",
    "number_of_predictions": 0,
    "objective_fields": [],
    "private": true,
    "range": [
        1,
        150
    ],
    "resource": "model/4f6bdfe9035d075177000005",
    "rows": 150,
    "size": 4608,
    "source": "source/4f6bd5791552687fb5000003",
    "source_status": true,
    "status": {
        "code": 1,
        "message": "The model is being processed and will be created soon"
    },
    "updated": "2012-03-23T02:28:57.741177"
}
```

Again, the model is scheduled for creation, and you can retrieve its
status at any time by means of `get.sh` and its resource identifier.

## Creating predictions

You can now use the model resource identifier together with some
input parameters to ask for predictions, using `create_prediction.sh`:

```bash
~/bigml/io/bash $ ./create_prediction.sh model/4f6bdfe9035d075177000005 '{"000002":1.2}'
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1040    0   967  100    73    170     12  0:00:06  0:00:05  0:00:01  1729
{
    "code": 201,
    "created": "2012-03-23T02:52:23.651644",
    "credits": 0.01,
    "dataset": "dataset/4f6bdaf51552687fb3000006",
    "dataset_status": true,
    "fields": {
        "000002": {
            "column_number": 2,
            "datatype": "double",
            "name": "petal length",
            "optype": "numeric"
        },
        "000004": {
            "column_number": 4,
            "datatype": "string",
            "name": "species",
            "optype": "categorical"
        }
    },
    "input_data": {
        "000002": 1.2
    },
    "locale": "en-US",
    "model": "model/4f6bdfe9035d075177000005",
    "model_status": true,
    "name": "Prediction for species",
    "objective_fields": [
        "000004"
    ],
    "prediction": {
        "000004": "Iris-setosa"
    },
    "prediction_path": {
        "bad_fields": [],
        "next_predicates": [],
        "path": [
            {
                "field": "000002",
                "operator": "<=",
                "value": 2.45
            }
        ],
        "unknown_fields": []
    },
    "private": true,
    "resource": "prediction/4f6be5671552687fb5000005",
    "source": "source/4f6bd5791552687fb5000003",
    "source_status": true,
    "status": {
        "code": 5,
        "message": "The prediction has been created"
    },
    "updated": "2012-03-23T02:52:23.651667"
}
```
## Deleting resources

Given an identifier, the corresponding resource can be deleted with
`delete.sh`:

```bash
~/bigml/io/bash $ ./delete.sh prediction/4f6be5671552687fb5000005
~/bigml/io/bash $ ./get.sh prediction/4f6be5671552687fb5000005
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    65  100    65    0     0     12      0  0:00:05  0:00:05 --:--:--   211
{"code": 404, "status": {"code": -1104, "message": "Not found"}}
```
