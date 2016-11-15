#!/bin/bash
set -e

cp ./sites/default/default.settings.php ./sites/default/settings.php
chown -R www-data:www-data ./sites/default/files
chmod 777 ./sites/default/settings.php
