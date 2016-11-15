Drupal 6 to Drupal 8 migration example
=====

This project attempts to demonstrate how typical data might be migrated from
Drupal 6 to Drupal 8. `./scripts/run.sh` sets up everything for you in
Docker containers, and tells you what you should do to accomplish the
migration.

This very simple examples installs a Drupal 6 site with two content types:

 * `legacy_type_one` which has a `field_select` field with three options.
 * `legacy_type_two` which has a `field_anything` text field.
 * Both nodes have a `field_image` field.

In this example, we want to merge these two content types:

 * all `legacy_type_one` and `legacy_type_two` nodes should be imported as
   nodes of type `new_node_type`.
 * `field_select` and `field_anything` should be available in `new_node_type`.
 * `field_image` should be imported.

This was accomplished by following the instructions in the article [Custom Drupal-to-Drupal Migrations with Migrate Tools](https://drupalize.me/blog/201605/custom-drupal-drupal-migrations-migrate-tools), by William Hetherington, Drupalize.me, April 26, 2016; this resulted in
the yml files in `my_migration/config/install`, which can be modified.
Specifically, `migrate_plus.migration.upgrade_d6_node_legacy_type_one.yml` and
`migrate_plus.migration.upgrade_d6_node_legacy_type_two.yml` were modified


Prerequisites
-----

 * Docker (latest version).

Instructions
-----

Start up the system.

    ./scripts/run.sh

Follow the instructions on the screen. Here is what should happen if all goes
well:

 * New Drupal 6 and 8 websites will be installed.
 * You will be asked to go through the Drupal 6 GUI installer.
 * Once that is done, a series of new content types and new generated content
   will be created. (See the Drupal 6 content section below for details.)
 * You will be given login links to your Drupal 6 and Drupal 8 sites.

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
   you can then put in your migration module (and modify to customize). You
   might need to make a few changes: (1) set the source_base_path in the yml
   files as described in [this issue](https://www.drupal.org/node/2827914);
   (2) set the key to "upgrade" in `./my_migration/config/install/migrate_plus.migration_group.migrate_drupal_6.yml`.
 * `drush migrate-import --all` runs the import based on the migrators in your
   custom module.
 * `drush migrate-status` tells you what the migrator will do without actually
   doing it.

Note 1: If you run the upgrade by visiting the /upgrade page, which will not
use your custom processors, you can use the following database information:

  * Database host: drupal6database
  * Database name: drupal
  * Database username: drupal
  * Database password: drupal
  * (Source files:) Files directory: /drupal6code

Further resources
-----

 * The [Migrate Plus](http://drupal.org/project/migrate_plus) module.
 * [Drupal to Drupal 8 via Migrate API](https://www.chapterthree.com/blog/drupal-to-drupal-8-via-migrate-api)
   by Minnur Ynusov, Chapter Three Blog, April 6, 2016.
 * [Migrate Your Way to Drupal 8 Greatness](https://www.youtube.com/watch?v=_Muaoq3RsYQ),
   Benjamin Melançon (mlncn), July 27, 2016.
 * [Custom Drupal-to-Drupal Migrations with Migrate Tools](https://drupalize.me/blog/201605/custom-drupal-drupal-migrations-migrate-tools),
   by William Hetherington, Drupalize.me, April 26, 2016.
 * [Drupal 8 Migrations, part 4: Migrating Nodes from Drupal 7](http://www.metaltoad.com/blog/migrating-nodes-drupal-7-to-drupal-8), By Keith Dechant, December 10th, 2014, later upgraded for Drupal 8.2.

Drupal 6 content
-----

On your Drupal 6 site, a number of nodes should automatically be created with
the following data:

 * A content type called `legacy_type_one`
  * Should contain a select field `field_select` with items "one, two, three"
 * A content type called `legacy_type_two`
  * Should contain a text field `field_anything` which can contain anything.
 * Both content types should have a field called `field_image` with an image.
