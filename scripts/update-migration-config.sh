#!/bin/bash
#
# Once our Drupal 6 module contains the desired content, calling this
# script will run the commands from Custom Drupal-to-Drupal Migrations with
# Migrate Tools (https://drupalize.me/blog/201605/custom-drupal-drupal-migrations-migrate-tools),
# by William Hetherington, Drupalize.me, April 26, 2016. The result will be
# placed in my_migration/config/install/*
#
set -e

# Setting --legacy-root here seems to not do anything, see
# https://www.drupal.org/node/2827914, however it can't hurt.
./scripts/exec.sh drupal8 'drush cc drush && \
  drush migrate-upgrade \
    --configure-only --legacy-root=/drupal6code && \
  drush config-export --destination=/tmp/migrate && \
  cp \
    /tmp/migrate/migrate_plus.migration.* \
    /tmp/migrate/migrate_plus.migration_group.migrate_*.yml \
    /var/www/html/modules/custom/my_migration/config/install/'

echo '[info] Updated files in ./my_migration/config/install.'
