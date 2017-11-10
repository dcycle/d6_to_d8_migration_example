#/bin/bash
#
# Exports the Drupal 7 database to ./docker-resources/.
# (Files are shared by default and will be written to
# ./docker-resources/drupal7/files)
#
set -e

./scripts/exec.sh drupal7 'drush cc all'
./scripts/exec.sh drupal7 'drush sql-dump > /db/db.sql'
