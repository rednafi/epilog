#!/bin/bash

set -e

# Load environment variables from .env file.
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi


until docker inspect --format "{{json .State.Health }}" caddy | \
                        jq '.Status' | grep 'healthy'; do

    >&2 echo "Elk stack is unhealthy - waiting..."

    sleep 1
    done

    >&2 echo "Elk stack is healthy - proceeding..."
