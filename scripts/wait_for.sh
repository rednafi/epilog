#!/bin/sh

set -e

# Load environment variables from .env file.
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi


wait_for () {
    until \
        curl -X GET $1 -u ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD}\
        -s -o /dev/null --head -w "%{http_code}" | grep 200 > /dev/null; do

    >&2 echo "$2 is unavailable - waiting..."

    sleep 1
    done

    >&2 echo "$2 is up - proceeding..."

}

wait_for http://elasticsearch:9200 Elasticsearch

wait_for http://kibana:5601/api/features Kibana
