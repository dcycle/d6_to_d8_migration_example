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
./scripts/exec.sh drupal6 '/run-import.sh'

echo '[info] Building a new Drupal 8 site.'
# Doing this now allows the Mysql container to warm up while the user installs
# Drupal 6.
./scripts/exec.sh drupal8 '/run.sh'

echo ' => '
echo ' => If all went well you can now access your sites at:'
echo ' => '
echo " =>  Drupal 6 => "$(./scripts/uli.sh drupal6)
echo " =>  Drupal 8 => "$(./scripts/uli.sh drupal8)
echo " => "
echo " => See the 'Perform imports' section of the README.md file for what to"
echo " => do next"
echo " => "
