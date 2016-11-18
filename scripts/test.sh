#/bin/bash
#
# Run tests.
#
set -e

# Create the environment.
./scripts/run.sh

# Run the migration as described in the README.md
docker-compose exec drupal8 /bin/bash -c 'drush en -y my_migration'
docker-compose exec drupal8 /bin/bash -c 'drush cc drush'
docker-compose exec drupal8 /bin/bash -c 'drush migrate-status'
docker-compose exec drupal8 /bin/bash -c 'drush migrate-import --all'

docker-compose exec drupal8 /bin/bash -c 'drush eval my_migration_test()'

# Make sure we can restore Drupal 8 to its pristine state.
./scripts/restore-newly-installed.sh
