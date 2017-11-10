#!/bin/bash
#
# Export Drupal 7 node as Json.
#
if [ -z "$1" ]; then
  echo -e '[error] Please pass a nid to this script'
  exit 1
fi
NID="$1"
echo "[info] exporting Drupal 7 node $NID as json to be parsed."
./scripts/run-drupal7.sh \
  "drush eval 'print_r(json_encode(node_load($NID)))'" > \
  ./workspace/workspace/exported/"$NID".json
