#!/bin/bash

RESOURCE=${1}
QUERY_STRING=${2}

if [ -z "$RESOURCE" ]; then
    echo "Usage: ./get.sh  [source/id | dataset/id | model/id | prediction/id]"
    exit 1
else
    curl "$BIGML_URL$RESOURCE?$BIGML_AUTH;$QUERY_STRING" | python -m json.tool
fi
