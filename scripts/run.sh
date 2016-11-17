#/bin/bash
#
# Provide an example of how migration can be done.
#
set -e

echo '[info] Destroying old Docker containers.'
./scripts/destroy.sh

echo '[info] Creating the new Docker containers.'
docker-compose build
docker-compose up -d

echo '[info] Waiting a few seconds for the MySQL container to warm up.'
sleep 20

echo '[info] Importing the Drupal 6 database.'
docker-compose exec drupal6 /run-import.sh

echo '[info] Building a new Drupal 8 site.'
# Doing this now allows the Mysql container to warm up while the user installs
# Drupal 6.
docker-compose exec drupal8 /run.sh

echo ' => '
echo ' => If all went well you can now access your sites at:'
echo ' => '
echo " =>  Drupal 6 => "$(./scripts/uli.sh drupal6)
echo " =>  Drupal 8 => "$(./scripts/uli.sh drupal8)
echo " => "
echo " => You are almost done, your Drupal 6 site should now contain some"
echo " => data and your Drupal 8 site should be empty. Run the following"
echo " => command to import data from Drupal 6 to Drupal 8:"
echo " => "
echo " =>     docker-compose exec drupal8 /bin/bash -c 'drush en -y my_migration'"
echo " =>     docker-compose exec drupal8 /bin/bash -c 'drush cc drush'"
echo " =>     docker-compose exec drupal8 /bin/bash -c 'drush migrate-status'"
echo " => "
echo " => You can actually run the script like this:"
echo " => "
echo " =>     docker-compose exec drupal8 /bin/bash -c 'drush migrate-import --all'"
echo " => "
echo " => The above will apply only those migrators that are defined in our"
echo " => my_migration module. To blindly migrate everything from Drupal 6"
echo " => to Drupal 8, you can run:"
echo " => "
echo " =>     docker-compose exec drupal8 /bin/bash -c 'drush cc drush'"
echo " =>     docker-compose exec drupal8 /bin/bash -c 'drush migrate-upgrade --legacy-root=/drupal6code'"
echo " => "
echo " => You can then modify the same node on Drupal 6 and Drupal 8 and run:"
echo " => "
echo " =>     docker-compose exec drupal8 /bin/bash -c 'drush migrate-import --all --update'"
echo " => "
echo " => This will **delete** the change you made to the Drupal 8 nodes"
echo " => re-import the change you made in Drupal 6."
echo " => "
echo " => If you want to reset Drupal 8 to the state it was in before you"
echo " => enabled my_migration (for example if you want to modify the yml files"
echo " => in ./my-migration/config/install), you can run:"
echo " => "
echo " =>     ./scripts/restore-newly-installed.sh"
echo " => "
