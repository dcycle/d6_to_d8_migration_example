#/bin/bash
#
# Run tests on an existing environment.
#
set -e

# Make sure we can restore Drupal 8 to its pristine state.
./scripts/restore-newly-installed.sh

./scripts/exec.sh drupal8 'drush en -y my_migration'
./scripts/exec.sh drupal8 'drush cc drush'
./scripts/exec.sh drupal8 'drush migrate-status'
./scripts/exec.sh drupal8 'drush migrate-import --all'

./scripts/test-existing-site.sh
