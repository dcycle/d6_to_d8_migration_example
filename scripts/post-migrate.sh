#!/bin/bash
#
# Post export.
#
# Pass a nid to perform the operation on only one nid.
#
if [ -z "$1" ]; then
  ./scripts/export-all-as-json.sh
  NIDS=$(./scripts/run-drupal6.sh 'echo "select nid from node" | drush sqlc' | grep -v 'nid')
  for NID in $NIDS; do
    ./scripts/run-drupal8.sh "drush eval 'my_migration_post_migrate($NID)'"
  done
else
  if [ -z "$2" ]; then
    # Only recreate the json if the second parameter is not set. This allows
    # for faster development with:
    #   ./scripts/post-migrate.sh 323 no-export
    ./scripts/export-single-as-json.sh "$1"
  fi
  ./scripts/run-drupal8.sh "drush eval 'my_migration_post_migrate($1)'"
fi

if [ -z "$2" ]; then
  ./scripts/run-drupal8.sh "drush eval 'my_migration_cleanup()'"
fi
