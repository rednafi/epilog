#!/bin/sh

set -e

if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi


curl -X PUT "http://elasticsearch:9200/_ilm/policy/cleanup_policy?pretty" \
     -H 'Content-Type: application/json' \
     -u ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} \
     -d '{
      "policy": {
        "phases": {
          "hot": {
            "actions": {}
          },
          "delete": {
            "min_age": "${PURGE_AFTER}d",
            "actions": { "delete": {} }
          }
        }
      }
    }'


curl -X PUT "http://elasticsearch:9200/${INDEX_PREFIX}-*/_settings?pretty" \
     -H 'Content-Type: application/json' \
     -u ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} \
     -d '{ "lifecycle.name": "cleanup_policy" }'



curl -X PUT "http://elasticsearch:9200/_template/logging_policy_template?pretty" \
     -H 'Content-Type: application/json' \
     -u ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} \
     -d '{
      "index_patterns": ["${INDEX_PREFIX}-*"],
      "settings": { "index.lifecycle.name": "cleanup_policy" }
    }'


curl -X POST "http://elasticsearch:9200/${INDEX_PREFIX}-*/_ilm/remove?pretty"\
     -u ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD}


curl -X PUT "http://elasticsearch:9200/${INDEX_PREFIX}-*/_settings?pretty" \
     -H 'Content-Type: application/json' \
     -u ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} \
     -d '{ "lifecycle.name": "cleanup_policy" }'
