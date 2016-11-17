#!/bin/bash
#
# This script will restore Drupal 8 to its newly installed state..
#
set -e

rm -rf /var/www/html/sites/default/files
cp -r /newly-installed-files /var/www/html/sites/default/files
chown -R www-data:www-data /var/www/html/sites/default/files
echo "drop database drupal" | mysql --user=drupal --password=drupal --host=drupal8database
echo "create database drupal" | mysql --user=drupal --password=drupal --host=drupal8database
drush sqlc < /newly-installed-database.sql
