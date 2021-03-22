#!/bin/bash
set -e

docker build -t registry.digitalocean.com/bloople/servel .
#docker push registry.digitalocean.com/bloople/servel