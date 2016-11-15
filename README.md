Drupal 6 to Drupal 8 migration example
=====

This project attempts to demonstrate how typical data might be migrated from
Drupal 6 to Drupal 8.

This very simple examples installs a Drupal 6 site with two content types:

 * `legacy_type_one` which has a `field_select` field with three options.
 * `legacy_type_two` which has a `field_anything` text field.
 * Both nodes have a `field_image` field.

In this example, we want to merge these two content types:

 * all `legacy_type_one` and `legacy_type_two` nodes should be imported as
   nodes of type `new_node`.
 * `field_select` and `field_anything` should be available in `new_node`.
 * `field_image` should be imported.

Prerequisites
-----

 * Docker (latest version).

Instructions
-----

Start by starting up the system.

    ./scripts/run.sh

Follow the instructions on the screen. Here is what should happen if all goes
well:

 * You will be asked to install a new Drupal 6 site with the GUI installer.
 * Once that is done, a series of new content types and new generated content
   will be created. (See the Drupal 6 content section below for details.)
 * You will be login links to your Drupal 6 and Drupal 8 sites.
 *

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

On your Drupal 6 site, 50 nodes should automatically be created with the
following data:

 * A content type called `legacy_type_one`
  * Should contain a select field `field_select` with items "one, two, three"
 * A content type called `legacy_type_two`
  * Should contain a text field `field_anything` which can contain anything.
 * Both content types should have a field called `field_image` with an image.
