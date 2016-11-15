#!/bin/bash
#
# Get a one-time login link on a container.
#

docker-compose exec "$1" /bin/bash -c \
  "drush -l http://$(docker-compose port "$1" 80) uli"
