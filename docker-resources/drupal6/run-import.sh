#!/bin/bash
#
# Import the database.
#
set -e

cp ./sites/default/default.settings.php ./sites/default/settings.php
chown -R www-data:www-data ./sites/default/files
chmod 777 ./sites/default/settings.php
echo '$db_url = "mysql://drupal:drupal@drupal6database/drupal";' >> \
  ./sites/default/settings.php

drush sqlc < /db/db.sql
