#/bin/bash
#
# Run tests on an existing site.
#
# Pass 'no-exec' as an argument to simulate what would happen on a
# Docker environment with an LXC driver which does not support exec.
#
set -e

./scripts/exec.sh drupal8 'drush eval "my_migration_test()"' "$1"
