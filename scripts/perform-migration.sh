#!/bin/bash
#
# Perform the actual migration.
#
set -e

./scripts/exec.sh drupal8 'drush migrate-upgrade --legacy-root=/drupal6code'
