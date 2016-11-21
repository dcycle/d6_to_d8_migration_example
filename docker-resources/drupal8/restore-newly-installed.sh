#!/bin/bash
#
# This script will restore Drupal 8 to its newly installed state..
#
set -e

rm -rf /var/www/html/sites/default/files/*
cp -r /newly-installed-files/* /var/www/html/sites/default/files/ \
  2>/dev/null || :
chown -R www-data:www-data /var/www/html/sites/default/files/* \
  2>/dev/null || :
echo "drop database drupal" | mysql --user=drupal --password=drupal --host=drupal8database
echo "create database drupal" | mysql --user=drupal --password=drupal --host=drupal8database
drush sqlc < /newly-installed-database.sql
