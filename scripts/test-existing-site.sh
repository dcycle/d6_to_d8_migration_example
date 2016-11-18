#/bin/bash
#
# Run tests on an existing site.
#
set -e

docker exec "$(docker-compose ps -q drupal8)" /bin/bash -c 'drush eval "my_migration_test()"'
