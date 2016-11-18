#!/bin/bash
#
# Get a one-time login link on a named container.
#

./scripts/exec.sh "$1" "drush -l http://$(docker-compose port "$1" 80) uli"
