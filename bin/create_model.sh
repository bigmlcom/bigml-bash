#!/bin/bash

DATASET=${1}
RESOURCE="model"

if [ -z $DATASET ]; then
    echo "Usage: ./create_model.sh dataset/id"
    exit 1
fi


curl "$BIGML_URL$RESOURCE?$BIGML_AUTH" \
     -X POST \
     -H "content-type: application/json" \
     -d "{\"dataset\": \"$DATASET\"}" \
     | python -m json.tool
