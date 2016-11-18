#/bin/bash
#
# Run tests on an existing site.
#
set -e

./scripts/exec.sh drupal8 'drush eval "my_migration_test()"'
