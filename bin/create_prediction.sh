#!/bin/bash

MODEL=${1}
DATA=${2:-"{}"}
RESOURCE="prediction"

if [ -z $MODEL ]; then
    echo "Usage: ./create_prediction.sh model/id [input-data]"
    exit 1
fi


curl "$BIGML_URL$RESOURCE?$BIGML_AUTH" \
     -X POST \
     -H "content-type: application/json" \
     -d "{\"model\": \"$MODEL\", \"input_data\": $DATA}" \
     -k | python -m json.tool
