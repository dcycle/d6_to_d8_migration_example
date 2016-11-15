#!/bin/bash
#
# This script is run when the Drupal docker container is ready. It prepares
# an environment for development or testing, which contains a full Drupal
# 8 installation with a running website and the drupal8tests module enabled.
#
set -e

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

cd /var/www/html && \
  drush en \
    migrate \
    migrate_drupal \
    migrate_drupal_ui \
    migrate_tools \
    migrate_plus \
    migrate_upgrade \
    my_migration \
    -y
  chown -R www-data:www-data ./sites/default/files && \
  drush cache-rebuild

# See https://drupalize.me/blog/201605/custom-drupal-drupal-migrations-migrate-tools
drush migrate-upgrade --configure-only --legacy-db-key=migrate
