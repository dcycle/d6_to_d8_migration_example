#!/bin/bash
set -e

# Cannot use drush si because of https://www.drupal.org/node/1569832
cp ./sites/default/default.settings.php ./sites/default/settings.php
chown -R www-data:www-data ./sites/default/files
chmod 777 ./sites/default/settings.php
