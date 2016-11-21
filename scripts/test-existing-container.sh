#/bin/bash
#
# Run tests on an existing environment.
#
# Pass 'no-exec' as an argument to simulate what would happen on a
# Docker environment with an LXC driver which does not support exec.
#
set -e

# Make sure we can restore Drupal 8 to its pristine state.
./scripts/restore-newly-installed.sh "$1"

./scripts/exec.sh drupal8 'drush en -y my_migration' "$1"
./scripts/exec.sh drupal8 'drush cc drush' "$1"
./scripts/exec.sh drupal8 'drush migrate-status' "$1"
./scripts/exec.sh drupal8 'drush migrate-import --all' "$1"

./scripts/test-existing-site.sh "$1"
