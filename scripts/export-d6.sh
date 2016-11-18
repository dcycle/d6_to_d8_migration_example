#/bin/bash
#
# Exports the Drupal 6 database to ./docker-resources/.
# (Files are shared by default and will be written to
# ./docker-resources/drupal6/files)
#
set -e

# https://github.com/docker/compose/issues/3379
docker exec "$(docker-compose ps -q drupal6)" /bin/bash -c 'drush cc all'
docker exec "$(docker-compose ps -q drupal6)" /bin/bash -c 'drush sql-dump > /db/db.sql'
