#!/bin/bash

FILE=${1}
RESOURCE="source"

if [ ! -f $FILE ]; then
    echo "Source file '$FILE' not readable"
    exit 1
fi

curl "$BIGML_URL$RESOURCE?$BIGML_AUTH" \
     -F file=@$FILE \
     | python -m json.tool
