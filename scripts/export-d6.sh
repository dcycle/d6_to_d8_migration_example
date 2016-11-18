#/bin/bash
#
# Exports the Drupal 6 database to ./docker-resources/.
# (Files are shared by default and will be written to
# ./docker-resources/drupal6/files)
#
set -e

./scripts/exec.sh drupal6 'drush cc all'
./scripts/exec.sh drupal6 'drush sql-dump > /db/db.sql'
