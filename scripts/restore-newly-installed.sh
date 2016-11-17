#!/bin/bash
#
# Restore Drupal 8 as it was when it was newly installed.
#
set -e

docker-compose exec drupal8 /bin/bash -c '/restore-newly-installed.sh'
