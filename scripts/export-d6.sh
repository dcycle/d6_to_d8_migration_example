#/bin/bash
#
# Exports the Drupal 6 database to ./docker-resources/.
# (Files are shared by default and will be written to
# ./docker-resources/drupal6/files)
#
set -e

docker-compose exec drupal6 'drush cc all; drush sql-dump' > \
  ./docker-resources/drupal6-database.sql
