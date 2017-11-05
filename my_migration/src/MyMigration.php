<?php

namespace Drupal\my_migration;
use Drupal\my_migration\

class MyMigration {

  public function runPostMigrate($nid) {
    $d6node = $this->getDrupal6NodeObject($nid);
    $d8node = node_load($nid);
    if (!$d6node) {
      print_r('[info] No Drupal 6 node with nid ' . $nid . PHP_EOL);
      return;
    }
    if (!$d8node) {
      print_r('[info] No Drupal 8 node with nid ' . $nid . PHP_EOL);
      return;
    }
    $processor = $this->getProcessor($d6node, $d8node);
    $processor->process();
  }

  public function getProcessor($d6node, $d8node) {
    switch ($d6node->type) {
      default:
        return new MyMigrationNodeProcessor($d6node, $d8node);
    }
  }

  /**
   * Get the decoded json description of the D6 node previously exported.
   *
   * @param int $nid
   *   The nid of the node.
   */
  public function getDrupal6NodeObject($nid) {
    $return = json_decode(file_get_contents("/exported/$nid.json"));
    // You can uncomment the following line to see what the node looks like.
    print_r($return);
    return $return;
  }

  public function cleanup() {
    $types = array(
      // If you want to delete content types here, you can add their names to
      // the list:
      'some-content-type-to-delete',
    );
    foreach ($types as $type) {
      $content_type = \Drupal::entityManager()->getStorage('node_type')->load($type);
      if ($content_type) {
        print_r('[info] About to delete content type ' . $type . PHP_EOL);
        $content_type->delete();
      }
      else {
        print_r('[info] Content type does not exist, moving on: ' . $type . PHP_EOL);
      }
    }
  }

}
