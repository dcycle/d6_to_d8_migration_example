#!/bin/bash
#
# Run a Drush command on your Drupal 8 container.
#
set -e

if [ "$2" ]; then
  echo 'Please enclose your drush commands in quotations.'
  echo 'For example: ./scripts/drush.sh "si -y".'
  exit 1
fi

docker-compose exec drupal8 /bin/bash -c \
  "drush -l http://$(docker-compose port drupal8 80) $1"
