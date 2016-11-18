#!/bin/bash
#
# This script is run when the Drupal docker container is ready. It prepares
# an environment for development or testing, which contains a full Drupal
# 8 installation with a running website and the drupal8tests module enabled.
#
set -e

# In order to migrate from Drupal 6, we need access to the entire Drupal 6
# codebase. When importing, Drupal 8 assumes we a path to the root of
# Drupal 6, which is why we need the directory structure
# sites/default/files.
- ./docker-resources/drupal6/files:/drupal6code/sites/default/files
- ./my_migration:/var/www/html/modules/custom/my_migration


# Install Drupal.
# In order to prevent the "unable to send mail" error, we are including
# the "install_configure_form" line, which itself forces us to include the
# profile (standard), which would otherwise be optional. See the output
# of "drush help si" from where this is taken.
cd /var/www/html && \
  drush si \
  --account-name=admin \
  --account-pass=admin \
  --db-url=mysql://drupal:drupal@drupal8database/drupal \
  -y \
  standard \
  install_configure_form.update_status_module='array(FALSE,FALSE)'

cat /settings.php-migrate.txt >> /var/www/html/sites/default/settings.php

# We are purposefully not enabling my_migration here, because we want to have
# a chance to run and debug ./scripts/update-migration-config.sh before
# the migrations exist in our local configuration.
cd /var/www/html && \
  drush en \
    migrate \
    migrate_drupal \
    migrate_drupal_ui \
    migrate_tools \
    migrate_plus \
    migrate_upgrade \
    -y
  chown -R www-data:www-data ./sites/default/files && \
  drush cache-rebuild && \
  drush cc drush

# Keep a fresh copy of the database in case we mess something up during
# development or testing. Then we'll be able restore with:
# ./scripts/restore-newly-installed.sh
drush sql-dump > /newly-installed-database.sql
cp -r /var/www/html/sites/default/files /newly-installed-files
