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
echo '[info] Running pre-run steps on Drupal 6 site without installing it.'
docker-compose exec drupal6 /run.sh

echo " => "
echo " => Please go to http://$(docker-compose port drupal6 80) and install the"
echo " => Drupal 6 site using the GUI installer, then press any key."
echo " => "
echo " =>    Use the following information"
echo " =>      Database name: drupal"
echo " =>      Database username: drupal"
echo " =>      Database password: drupal"
echo " =>      (Advanced options:) Database host: drupal6database"
echo " => "
echo " =>    PRESS ENTER WHEN THE ABOVE IS DONE."
echo " => "

read USERINPUT

echo '[info] Building a new Drupal 8 site.'
# Doing this now allows the Mysql container to warm up while the user installs
# Drupal 6.
docker-compose exec drupal8 /run.sh
docker-compose exec drupal6 /run-post-install.sh

echo ''
echo 'If all went well you can now access your sites at:'
echo ''
echo " Drupal 6 => "$(./scripts/uli.sh drupal6)
echo " Drupal 8 => "$(./scripts/uli.sh drupal8)
echo " => "
echo " => Please add at least one image to a node on Drupal 6 and remember the"
echo " => node to which you added it."
echo " => "
echo " =>    The site will not be able to generate a thumbnail, this is not"
echo " =>    a problem for our purposes."
echo " => "
echo " =>    PRESS ENTER WHEN THE ABOVE IS DONE."
echo " => "

read USERINPUT

echo " => "
echo " => You are almost done, your Drupal 6 site should now contain some"
echo " => data and your Drupal 8 site should be empty. Run the following"
echo " => command to import data from Drupal 6 to Drupal 8:"
echo " => "
echo " =>     docker-compose exec drupal8 /bin/bash -c 'drush cc drush && drush migrate-status'"
echo " => "
echo " => You can actually run the script like this:"
echo " => "
echo " =>     docker-compose exec drupal8 /bin/bash -c 'drush migrate-import --all'"
echo " => "
echo " => You can then modify the same node on Drupal 6 and Drupal 8 and run:"
echo " => "
echo " =>     docker-compose exec drupal8 /bin/bash -c 'drush migrate-import --all --update'"
echo " => "
echo " => This will **delete** the change you made to the Drupal 8 node and"
echo " => re-import the change you made in Drupal 6."
echo " => "
