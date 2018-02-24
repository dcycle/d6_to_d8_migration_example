aDrupal 6 (and 7) to Drupal 8 migration example
=====

This project attempts to demonstrate how typical data might be migrated from
Drupal 7 to Drupal 8.

Branches
-----

* [6 (default branch)](https://github.com/dcycle/d6_to_d8_migration_example/tree/6): For migrating from Drupal 6 to Drupal 8. [![CircleCI](https://circleci.com/gh/dcycle/d6_to_d8_migration_example/tree/6.svg?style=svg)](https://circleci.com/gh/dcycle/d6_to_d8_migration_example/tree/6)
* [7](https://github.com/dcycle/d6_to_d8_migration_example/tree/7): For migrating from Drupal 7 to Drupal 8. [![CircleCI](https://circleci.com/gh/dcycle/d6_to_d8_migration_example/tree/7.svg?style=svg)](https://circleci.com/gh/dcycle/d6_to_d8_migration_example/tree/7)

About
-----

This project is self-contained and can be run as-is; it is meant to demonstrate
the migration process.

`./scripts/run.sh` sets up everything for you in
Docker containers, and tells you what you should do to accomplish the
migration.

This project will install, in Docker containers, a Drupal 7 site with some
custom content; a brand new empty Drupal 8 site; and give you instructions
on how to perform a migration from one to the other.

The Drupal 7 site has two content types with associated content:

 * `legacy_type_one` which has a `field_select` field with three options.
 * `legacy_type_two` which has a `field_anything` text field.
 * Both node types have a `field_image` field.
 * There are a hundred nodes in the Drupal 7 site.

In this example:

 * All `legacy_type_one` and `legacy_type_two` nodes should be imported as
   nodes of type `new_node_type`.
 * `field_select` and `field_anything` should be available in `new_node_type`.
 * `field_select` should be renamed to `field_new_select`.
 * `field_image` should be imported.
 * Content of type `page` and `story` should be ignored.
 * We are including automated tests and continuous integration to make sure the import happened correctly.

This was accomplished by following the instructions in the article [Custom Drupal-to-Drupal Migrations with Migrate Tools](https://drupalize.me/blog/201605/custom-drupal-drupal-migrations-migrate-tools), by William Hetherington, Drupalize.me, April 26, 2016; this resulted in
the yml files in `my_migration/config/install`, which can be modified.
Amont others, `migrate_plus.migration.upgrade_d7_node_legacy_type_one.yml` and
`migrate_plus.migration.upgrade_d7_node_legacy_type_two.yml` were modified

Known issues and troubleshooting
-----

 * Please consult the [issue queue](https://github.com/dcycle/d6_to_d8_migration_example/issues) and report any issues there.
 * "MySQL server gone away" and memory issues have in my experience been linked to host system resources. Increase your RAM and disk space.
 * Using Docker on Mac OS X, you might get a MySQL container status perpetually at "Restarting (1)". This might be linked to your Docker data taking up too much space. Doing a factory reset of Docker in the preferences has fixed this for me.

Prerequisites
-----

 * Docker (latest version) and Docker-compose (latest version); tested using Docker for mac OS native.

Instructions (simple)
-----

### 1. Start up the system

    ./scripts/run.sh

If all goes well:

 * A Drupal 7 with custom content types (and content) will be created.
 * A brand new empty Drupal 8 site will be created.
 * You will be given login links to your Drupal 7 and Drupal 8 sites.
 * You can follow the instructions below to actually perform the migration.

### 2. Perform imports

Your Drupal 7 site should now contain some data and your Drupal 8 site should
be empty. Run the following command to get information about the import:

    docker-compose exec drupal8 'drush en -y my_migration'
    docker-compose exec drupal8 'drush cc drush'
    docker-compose exec drupal8 'drush migrate-status'

You can actually run the import like this:

    docker-compose exec drupal8 'drush migrate-import --all'

You can then modify the same node on Drupal 7 and Drupal 8 and run:

    docker-compose exec drupal8 'drush migrate-import --all --update'

This will **delete** the change you made to the Drupal 8 nodes
re-import the change you made in Drupal 7.

The above process will apply only those migrators that are defined in our
my_migration module, which processes content before migrating it. To blindly
migrate _everything_ from Drupal 7 to Drupal 8, you can run:

    ./scripts/restore-newly-installed.sh
    docker-compose exec drupal8 'drush cc drush'
    docker-compose exec drupal8 'drush migrate-upgrade --legacy-root=/drupal7code'

If you want to reset Drupal 8 to the state it was in before you
performed a migration (for example if you want to modify the yml files
in ./my-migration/config/install), you can run:

    ./scripts/restore-newly-installed.sh

Instructions to avoiding ID collisions during incremental migrations
-----

The following is a sample workaround for an [incremental id collision issue](https://www.drupal.org/project/drupal/issues/2748609) which exists in core at the time of this writing.

Let's first see the problem:

Restore everything to the way it was before the migration:

    docker-compose exec drupal8 'drush en -y my_migration'
    docker-compose exec drupal8 'drush cc drush'

Now go to `/admin/structure/types/manage/legacy-type-one` and make sure you set "create new revision" in the publishing options.

Now run your migration:

    docker-compose exec drupal8 'drush migrate-import --all'

At this point, let's the latest nid, vid, uid, tid and fid and Drupal 8:

      (docker-compose exec drupal8 /bin/bash -c \
        'echo "SELECT nid FROM node \
        ORDER BY nid DESC LIMIT 1" | drush sqlc'
      docker-compose exec drupal8 /bin/bash -c \
        'echo "SELECT vid FROM node_revision \
        ORDER BY vid DESC LIMIT 1" | drush sqlc'
      docker-compose exec drupal8 /bin/bash -c \
        'echo "SELECT uid FROM users \
        ORDER BY uid DESC LIMIT 1" | drush sqlc'
      docker-compose exec drupal8 /bin/bash -c \
        'echo "SELECT tid FROM taxonomy_term_data \
        ORDER BY tid DESC LIMIT 1" | drush sqlc'
      docker-compose exec drupal8 /bin/bash -c \
        'echo "SELECT fid FROM file_managed \
        ORDER BY fid DESC LIMIT 1" | drush sqlc')

And Drupal 7:

      (docker-compose exec drupal7 /bin/bash -c \
        'echo "SELECT nid FROM node \
        WHERE type in ('"'"'legacy_type_one'"'"', \
        '"'"'legacy_type_two'"'"') \
        ORDER BY nid DESC LIMIT 1" | drush sqlc'
      docker-compose exec drupal7 /bin/bash -c \
        'echo "SELECT vid FROM node_revision \
        ORDER BY vid DESC LIMIT 1" | drush sqlc'
      docker-compose exec drupal7 /bin/bash -c \
        'echo "SELECT uid FROM users \
        ORDER BY uid DESC LIMIT 1" | drush sqlc'
      docker-compose exec drupal7 /bin/bash -c \
        'echo "SELECT tid FROM taxonomy_term_data \
        ORDER BY tid DESC LIMIT 1" | drush sqlc'
      docker-compose exec drupal7 /bin/bash -c \
        'echo "SELECT fid FROM file_managed \
        ORDER BY fid DESC LIMIT 1" | drush sqlc')

Let's now make sure to increment these on both Drupal 7 and Drupal 8:

* Add an image to an existing node in Drupal 7.
* Add a new node on D8 with a new image.
* Add a new taxonomy term to D7 and D8.
* Add a new user to D7 and another one to D8, making sure they have the same UID (you might have to create several in D8 to get to the same UID as the one D7).
* Edit a legacy_node_one node on D7, making sure to create a new revision.
* Edit a node in D8 (which does not have the same revision as D7 node you just edited) and make sure to add a new revision.

Now you can confirm that your nids, vids, uids, tids and fids have been incremented on both your systems. However **the same incremental IDs no longer link to the same data on both systems**. Let's see what this does:

    docker-compose exec drupal8 'drush migrate-import --all --update'

At this point:

* the taxonomy term you added on D7 **replaces** the one you added on D8.
* the image you added to a node in D7 **replaces** the image on the new node in D8.
* the D7 user **replaces** the D8 user.
* You will get some ugly errors like:

    `Drupal\Core\Entity\EntityStorageException: Update existing 'node'        [error]
    entity revision while changing the revision ID is not supported. in
    Drupal\Core\Entity\ContentEntityStorageBase->doPreSave() (line 303 of
    /var/www/html/core/lib/Drupal/Core/Entity/ContentEntityStorageBase.php).`

In essence, some really ugly stuff if you want to do gradual migrations...

The solution, and some advanced techniques to deal with this, can be tracked in [this issue on Drupal.org](https://www.drupal.org/project/drupal/issues/2748609).

Meanwhile, here is a rather simple technique that might work for your needs; let's start by resetting everything:

    ./scripts/restore-newly-installed.sh
    docker-compose exec drupal8 'drush en -y my_migration'
    docker-compose exec drupal8 'drush cc drush'
    docker-compose exec drupal8 'drush migrate-status'

**But before going forward**, let's bump the auto_increment values to insanely high values on Drupal 8:

    (docker-compose exec drupal8 /bin/bash -c \
      'echo "ALTER TABLE node AUTO_INCREMENT = 500000" \
      | drush sqlc'
    docker-compose exec drupal8 /bin/bash -c \
      'echo "ALTER TABLE node_revision AUTO_INCREMENT = 500000" \
      | drush sqlc'
    docker-compose exec drupal8 /bin/bash -c \
      'echo "ALTER TABLE taxonomy_term_data AUTO_INCREMENT = 500000" \
      | drush sqlc'
    docker-compose exec drupal8 /bin/bash -c \
      'echo "ALTER TABLE file_managed AUTO_INCREMENT = 500000" \
      | drush sqlc')

This being Drupal, [we can't auto-increment users the same way](https://www.drupal.org/project/drupal/issues/1209466). My solution is create a dummy user with a high uid; this will force further users to have higher uids:

    $values = [
      'field_first_name' => 'Placeholder dummy user',
      'fieldt_last_name' => 'Placeholder dummy user',
      'name' => 'dummy-user-bump-to-25000',
      'mail' => 'test@test.com',
      'roles' => array(),
      'pass' => rand() . rand() . rand() . rand() . rand() . rand(),
      'status' => 0,
      'uid' => 25000,
    ];
    $account = entity_create('user', $values);
    $account->save();

If you want to run this code on your D8 site, you can enable the Devel module:

    docker-compose exec drupal8 /bin/bash -c \
      'drush dl devel && drush en -y devel'

Then navigate to /devel/php and enter the PHP code above.

In my tests, this approach can work in cases where we are dealing with incremental IDs. Please make sure to audit your content for any incremental IDs to avoid data loss, and keep watching the corresponding [Drupal.org issue](https://www.drupal.org/project/drupal/issues/2748609).

Preparing your own migration: step-by-step guide
-----

You will end up with a Drupal 8 database dump (`.mysql` file) you can import to
your host of choice. Our approach will be to build a small model of our
Drupal 7 site using [Features](https://drupal.org/project/features), then
use that to import generated content to our Drupal 8 site.

### Step one: prepare what you need

 * Make sure you have the latest version of Docker installed locally.
 * Make sure you have a full mysql dump of your Drupal 7 database.
 * Make sure you have your entire Drupal 7 codebase including Drupal root.
 * If your legacy site is using multisite, you might need to adapt the steps
   below.

### Step two: create a _feature_ based on your legacy Drupal 7 site

Make sure the `features` module is on your Drupal 7 site, and enable `features`.

 * Log in as user 1 on your Drupal 7 site -- preferably a development
   environment, local or remote.
 * Go the edit each one of your vocabularies and assign it a "machine name".
 * Go to /admin/build/features/create and create a new feature named
   drupal7structure which should contain the full list of elements of the
   following types (not only those elements you want, but all of them):
   CCK: Content, Content type: node, Dependencies, Vocabularies:
   fe_taxonomy_vocabulary. Do not select anything else.
 * Download it to your computer.
 * If the list at /admin/build/features contains features which have relevant
   elements of type CCK: Content, Content type: node, you may need to tweak
   the following steps.
 * Copy _all_ contrib modules _except_ cck, devel, features, filefield and
   imagefield in your legacy codebase _into_ the feature you just downloaded.

### Step three: download a working copy of this project

If you want to track your migration project in its own repo, you can also fork
this project.

    cd ~/Desktop
    git clone https://github.com/alberto56/d6_to_d8_migration_example.git
    cd ./d6_to_d8_migration_example

### Step four: modify this project to contain your own feature

Place the feature your downloaded earlier at
`./docker-resources/drupal7/drupal7structure`.

### Step five: create the migration environment

    ./scripts/run.sh

### Step six: manually fetch dependencies of your drupal7structure

The above will import the sample Drupal 7 database with its `legacy_type_one`
and `legacy_type_two` into a Drupal 7 environment. We will replace these below
with elements defined by your feature.

    ./scripts/run-drupal7.sh "drush dis -y drupal7structure"
    ./scripts/run-drupal7.sh "drush pm-uninstall -y drupal7structure"
    ./scripts/run-drupal7.sh "drush en -y drupal7structure"
    ./scripts/run-drupal7.sh "drush cc drush && drush fra -y"

If this tells you there are unmet dependencies, make sure you placed your
contrib modules in your legacy codebase _into_ the feature you downloaded (see
above) previously and restart from step two, above.

If certain modules are giving you trouble (for example, not meeting mimumum
requirements and refusing to install), you might have luck by removing
them from the dependency list and restarting at step two.

### Step seven: create a representative content on your new site

Log into the Drupal 7 site:

    ./scripts/uli.sh drupal7

You should create one node of each content type (including those you do not want
to import), with all fields filled in with realistic content, including files
and pictures, as well as add picture support to users at /admin/user/settings
and add a picture to user 1.

The idea is to create a Drupal 7 site from scratch to be as representative as
possible of your real database without the corruption and bloat of the latter.

Note: image uploads will not generate thumbnails on the D7 environment, but
everything will still work.

You might want to take note of the nodes to check, for example:

 * node 34 of type x should not exist in target.
 * node 37 of type y should have a valid image in field_my_image.
 * ...

### Step eight: export the Drupal 7 database

    ./scripts/run-drupal7.sh "drush cc all && drush sql-dump > /db/db.sql"

### Step nine: start developing the migration code

    ./scripts/run.sh

Will confirm everything is going well until now; log onto your D7 site and
confirm the database was imported properly.

At this point the migration scripts are still designed for the original
sample D7 content (legacy_type_two, etc). Update these by typing:

    ./scripts/update-migration-config.sh

The above will update the migration scripts in `./my_migration/config/install`.

You will need to tweak the migration node yml files as per
[this issue](https://www.drupal.org/node/2828808) in order for images to be
properly imported.

### Step ten: test the migration code

At this point you can start the following cycle iteratively until you get your
migration code working as desired:

Brings your D8 site to a pristine state:

    ./scripts/restore-newly-installed.sh

Run your migration:

    docker-compose exec drupal8 'drush en -y my_migration'
    docker-compose exec drupal8 'drush cc drush'
    docker-compose exec drupal8 'drush migrate-import --all'

Check the results by opening the same node on your Drupal 7 and Drupal 8 sites.

    ./scripts/uli.sh drupal7
    ./scripts/uli.sh drupal8

Make sure the data you noted in step 7 has been migrated (or ignored) as
expected:

  * node 34 of type x should not exist in target.
  * node 37 of type y should have a valid image in field_my_image.
  * ...

To run automated tests you can modify
`./my_migration/my_migration_test/src/MyMigrationTest.php` and run:

    ./scripts/scripts-existing-site.sh

Fix what needs fixing, and repeat!

Difference between status, upgrade and import
-----

I have found the nuances between these to be confusing...

 * `drush migrate-upgrade --legacy-root=/drupal7code` (or visiting the
   `/upgrade` page (1)) is a basic import from an existing Drupal site to the
   current newly-created Drupal 8 site. This blindly imports all data from the
   source to the destination and does not require a custom module, and does not
   allow you to modify the data as it is being imported.
 * `drush migrate-upgrade --configure-only --legacy-root=/drupal7code` will
   generate default migrators and put them in the database. You can then run
   `drush config-export --destination=/tmp/migrate` to get the .yml files, which
   you can then put in your migration module (and modify to customize). If issue
   [#2828808 Migrate Upgrades:migrate-import does not link imported files to their file fields](https://www.drupal.org/node/2828808)
   is still open you might need to make a modification to your yml files for images
   to be imported correctly.
 * `drush migrate-import --all` runs the import based on the migrators in your
   custom module.
 * `drush migrate-status` tells you what the migrator will do without actually
   doing it.

Note 1: If you run the upgrade by visiting the GUI at the /upgrade page, which will not
use your custom processors, you can use the following database information:

  * Database host: drupal7database
  * Database name: drupal
  * Database username: drupal
  * Database password: drupal
  * (Source files:) Files directory: /drupal7code _or_ http://drupal7

Further resources
-----

 * The [Migrate Plus](http://drupal.org/project/migrate_plus) module by mikeryan.
 * The [Migrate Tools](http://drupal.org/project/migrate_tools) module by mikeryan.
 * The [Migrate Upgrade](http://drupal.org/project/migrate_upgrade) module by mikeryan.
 * [Drupal to Drupal 8 via Migrate API](https://www.chapterthree.com/blog/drupal-to-drupal-8-via-migrate-api)
   by Minnur Ynusov, Chapter Three Blog, April 6, 2016.
 * [Custom Drupal-to-Drupal Migrations with Migrate Tools](https://drupalize.me/blog/201605/custom-drupal-drupal-migrations-migrate-tools),
   by William Hetherington, Drupalize.me, April 26, 2016.
 * [Drupal 8 Migrations, part 4: Migrating Nodes from Drupal 7](http://www.metaltoad.com/blog/migrating-nodes-drupal-7-to-drupal-8), By Keith Dechant, December 10th, 2014.
