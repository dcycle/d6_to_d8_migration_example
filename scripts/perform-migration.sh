#!/bin/bash
#
# Perform the actual migration.
#
set -e

docker-compose exec drupal8 /bin/bash -c 'drush \
  migrate-upgrade --legacy-root=/drupal6code'
