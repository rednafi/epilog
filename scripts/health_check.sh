#!/bin/sh

set -e

# Load environment variables from .env file.
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

apk add curl
curl --fail http://es01:9200 \
    -u ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} || exit 1

curl -fail http://kib01:5601/api/features \
    -u ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} || exit 1
