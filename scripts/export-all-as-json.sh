#!/bin/bash
#
# Export Drupal 7 data as Json.
#
mkdir -p ./workspace/workspace/exported
NIDS=$(./scripts/run-drupal7.sh 'echo "select nid from node" | drush sqlc' | grep -v 'nid')
for NID in $NIDS; do
  ./scripts/export-single-as-json.sh "$NID"
done
