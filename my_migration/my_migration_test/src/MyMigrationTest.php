<?php

namespace Drupal\my_migration_test;

class MyMigrationTest {

  /**
   * Initialize some variables.
   */
  public function __construct() {
    $this->result = 'not yet started';
    $this->output = array();
    $this->errors = array();
  }

  /**
   * Get output from the test.
   */
  public function output() {
    return $this->output + $this->errors;
  }

  /**
   * Get errors from the test.
   */
  public function errors() {
    return $this->errors;
  }

  /**
   * Check a node and make sure it has the correct values.
   */
  public function checkNode($nid, $info) {
    $info = array(
      'exists' => TRUE,
    ) + $info;

    $node = \Drupal\node\Entity\Node::load($nid);
    if ($info['exists'] === FALSE) {
      if ($node) {
        $this->errors[] = 'Node ' . $nid . ' exists, but it should not.';
      }
      return;
    }
    if (isset($info['fields'])) {
      foreach ($info['fields'] as $name => $value) {
        if (substr($node->get($name)->value, 0, strlen($value)) != $value) {
          $this->errors[] = 'For ' . $nid . ', field ' . $name . ' does not start with ' . $value;
          return;
        }
        else {
          $this->output[] = 'For ' . $nid . ', field ' . $name . ' starts with ' . $value;
        }
      }
    }
    if (isset($info['filefields'])) {
      foreach ($info['filefields'] as $name => $value) {
        $this->checkFileField($node, $name, $value);
      }
    }
    if (isset($info['type'])) {
      if ($node->getType() != $info['type']) {
        $this->errors[] = 'For ' . $nid . ', type is not ' . $info['type'];
        return;
      }
      else {
        $this->output[] = 'For ' . $nid . ', type is ' . $info['type'];
      }
    }
  }

  /**
   * Run tests to make sure our processed migration happened as expected.
   */
  public function runTestProcessed() {
    $this->result = 'in progress';

    $this->checkNode(198, array(
      'fields' => array(
        'title' => 'Exputo Gilvus',
        'body' => 'node (legacy_type_two) - Olim secundum',
        'field_anything' => 'qUXeTn9QmZFJ',
      ),
      'type' => 'new_node_type',
      'filefields' => array(
        'field_image' => 'public://badge_rattlesnake.png',
      ),
    ));
    $this->checkNode(189, array(
      'fields' => array(
        'title' => 'Diam Gilvus',
        'body' => 'node (legacy_type_one) - Interdico',
        'field_select' => 'one',
      ),
      'type' => 'new_node_type',
    ));
    $this->checkNode(190, array(
      'exists' => FALSE,
    ));
    $this->checkNode(192, array(
      'exists' => FALSE,
    ));

    $this->result = 'success';
  }

  /**
   * Make sure a file field is set.
   */
  function checkFileField($node, $name, $value) {
    $id = $node->get($name)->get(0)->get('target_id');
    $uri = \Drupal\file\Entity\File::load((int)$id)->getFileUri();
    if ($uri != $value) {
      $this->errors[] = 'For ' . $node->id() . ', field ' . $name . ' is not ' . $value;
      return;
    }
    else {
      $this->output[] = 'For ' . $node->id() . ', field ' . $name . ' is ' . $value;
    }
  }

  /**
   * Get a result string, success, error, etc.
   */
  public function result() {
    if (count($this->errors)) {
      return 'error';
    }
    return $this->result;
  }

}
