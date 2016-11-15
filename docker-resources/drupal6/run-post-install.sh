#!/bin/bash
set -e

drush en -y drupal6structure
drush generate-content 100
# Delete the fist nodes. This allows us to test a situation where there
# are "missing" node ids on the source system.
drush generate-content 100 --kill
