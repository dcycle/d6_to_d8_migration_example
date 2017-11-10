#!/bin/bash
#
# Import the database.
#
set -e

drush sqlc < /db/db.sql
