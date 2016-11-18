#/bin/bash
#
# Exports the Drupal 6 database to ./docker-resources/.
# (Files are shared by default and will be written to
# ./docker-resources/drupal6/files)
#
set -e

docker-compose exec drupal6 /bin/bash -c 'drush cc all'
docker-compose exec drupal6 /bin/bash -c 'drush sql-dump > /db/db.sql'
