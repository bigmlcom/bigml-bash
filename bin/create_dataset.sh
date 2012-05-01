#!/bin/bash

SOURCE=${1}
RESOURCE="dataset"

if [ -z $SOURCE ]; then
    echo "Usage: ./create_dataset.sh source/id"
    exit 1
fi


curl "$BIGML_URL$RESOURCE?$BIGML_AUTH" \
     -X POST \
     -H "content-type: application/json" \
     -d "{\"source\": \"$SOURCE\"}" \
     | python -m json.tool
