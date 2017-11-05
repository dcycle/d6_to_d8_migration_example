#!/bin/bash
#
# Export Drupal 6 node as Json.
#
if [ -z "$1" ]; then
  echo -e '[error] Please pass a nid to this script'
  exit 1
fi
NID="$1"
echo "[info] exporting Drupal 6 node $NID as json to be parsed."
./scripts/run-drupal6.sh \
  "drush eval 'print_r(json_encode(node_load($NID)))'" > \
  ./workspace/workspace/exported/"$NID".json
