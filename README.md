Drupal 6 to Drupal 8 migration example
=====

This project attempts to demonstrate how typical data might be migrated from
Drupal 6 to Drupal 8.2.

This project is self-contained and can be run as-is; it is meant to demonstrate
the migraiton process.

`./scripts/run.sh` sets up everything for you in
Docker containers, and tells you what you should do to accomplish the
migration.

This project will install, in Docker containers, a Drupal 6 site with some
custom content; a brand new empty Drupal 8 site; and give you instructions
on how to perform a migration from one to the other.

The Drupal 6 site has two content types with associated content:

 * `legacy_type_one` which has a `field_select` field with three options.
 * `legacy_type_two` which has a `field_anything` text field.
 * Both node types have a `field_image` field.
 * There are a hundred nodes in the Drupal 6 site.

In this example:

 * All `legacy_type_one` and `legacy_type_two` nodes should be imported as
   nodes of type `new_node_type`.
 * `field_select` and `field_anything` should be available in `new_node_type`.
 * `field_image` should be imported.
 * Content of type `page` and `story` should be ignored.
 * We are including automated tests and continuous integration to make sure the
   import happened correctly:

[![CircleCI](https://circleci.com/gh/alberto56/d6_to_d8_migration_example/tree/master.svg?style=svg)](https://circleci.com/gh/alberto56/d6_to_d8_migration_example/tree/master)

This was accomplished by following the instructions in the article [Custom Drupal-to-Drupal Migrations with Migrate Tools](https://drupalize.me/blog/201605/custom-drupal-drupal-migrations-migrate-tools), by William Hetherington, Drupalize.me, April 26, 2016; this resulted in
the yml files in `my_migration/config/install`, which can be modified.
Amont others, `migrate_plus.migration.upgrade_d6_node_legacy_type_one.yml` and
`migrate_plus.migration.upgrade_d6_node_legacy_type_two.yml` were modified

Known issues and troubleshooting
-----

 * Please consult the [issue queue](https://github.com/alberto56/d6_to_d8_migration_example/issues) and report any issues there.

Prerequisites
-----

 * Docker (latest version).

Instructions
-----

### 1. Start up the system

    ./scripts/run.sh

Follow the instructions on the screen. Here is what should happen if all goes
well:

 * New Drupal 6 and 8 websites will be installed.
 * You will be given login links to your Drupal 6 and Drupal 8 sites.

### 2. Perform imports

Your Drupal 6 site should now contain some data and your Drupal 8 site should
be empty. Run the following command to import data from Drupal 6 to Drupal 8:

    ./scripts/exec.sh drupal8 'drush en -y my_migration'
    ./scripts/exec.sh drupal8 'drush cc drush'
    ./scripts/exec.sh drupal8 'drush migrate-status'

You can actually run the script like this:

    ./scripts/exec.sh drupal8 'drush migrate-import --all'

The above will apply only those migrators that are defined in our
my_migration module. To blindly migrate everything from Drupal 6
to Drupal 8, you can run:

    ./scripts/exec.sh drupal8 'drush cc drush'
    ./scripts/exec.sh drupal8 'drush migrate-upgrade --legacy-root=/drupal6code'

You can then modify the same node on Drupal 6 and Drupal 8 and run:

    ./scripts/exec.sh drupal8 'drush migrate-import --all --update'

This will **delete** the change you made to the Drupal 8 nodes
re-import the change you made in Drupal 6.

If you want to reset Drupal 8 to the state it was in before you
enabled my_migration (for example if you want to modify the yml files
in ./my-migration/config/install), you can run:

    ./scripts/restore-newly-installed.sh

Difference between status, upgrade and import
-----

I have found the nuances between these to be confusing...

 * `drush migrate-upgrade --legacy-root=/drupal6code` (or visiting the
   `/upgrade` page (1)) is a basic import from an existing Drupal site to the
   current newly-created Drupal 8 site. This blindly imports all data from the
   source to the destination and does not require a custom module, and does not
   allow you to modify the data as it is being imported.
 * `drush migrate-upgrade --configure-only --legacy-root=/drupal6code` will
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

  * Database host: drupal6database
  * Database name: drupal
  * Database username: drupal
  * Database password: drupal
  * (Source files:) Files directory: /drupal6code _or_ http://drupal6

Further resources
-----

 * The [Migrate Plus](http://drupal.org/project/migrate_plus) module by mikeryan.
 * The [Migrate Tools](http://drupal.org/project/migrate_tools) module by mikeryan.
 * The [Migrate Upgrade](http://drupal.org/project/migrate_upgrade) module by mikeryan.
 * [Drupal to Drupal 8 via Migrate API](https://www.chapterthree.com/blog/drupal-to-drupal-8-via-migrate-api)
   by Minnur Ynusov, Chapter Three Blog, April 6, 2016.
 * [Custom Drupal-to-Drupal Migrations with Migrate Tools](https://drupalize.me/blog/201605/custom-drupal-drupal-migrations-migrate-tools),
   by William Hetherington, Drupalize.me, April 26, 2016.
 * [Drupal 8 Migrations, part 4: Migrating Nodes from Drupal 7](http://www.metaltoad.com/blog/migrating-nodes-drupal-7-to-drupal-8), By Keith Dechant, December 10th, 2014, later upgraded for Drupal 8.2.
