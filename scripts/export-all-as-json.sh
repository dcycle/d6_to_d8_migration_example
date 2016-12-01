#!/bin/bash
#
# Export Drupal 6 data as Json.
#
mkdir -p ./workspace/workspace/exported
NIDS=$(./scripts/run-drupal6.sh 'echo "select nid from node" | drush sqlc' | grep -v 'nid')
for NID in $NIDS; do
  ./scripts/export-single-as-json.sh "$NID"
done
