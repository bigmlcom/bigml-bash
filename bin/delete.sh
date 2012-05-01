#!/bin/bash

RESOURCE=${1}

if [ -z $RESOURCE ]; then
    echo "Usage: ./delete.sh  [source/id | dataset/id | model/id | prediction/id]"
    exit 1
else
    curl -X DELETE "$BIGML_URL$RESOURCE?$BIGML_AUTH"
fi
