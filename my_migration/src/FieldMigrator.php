<?php

namespace Drupal\my_migration;

class FieldMigrator {

  public function __construct($node_processor, $nid, $d6, $d8) {
    $this->node_processor = $node_processor;
    $this->nid = $nid;
    $this->d6 = $d6;
    $this->d8 = $d8;
  }

  public function setD8($d8) {
    $this->d8 = $d8;
  }

  public function utcDate($date, $format = NULL) {
    if ($format) {
      return $date->format($format, array('timezone' => 'UTC'));
    }
    else {
      return $date->format('Y-m-d', array('timezone' => 'UTC')) . 'T' .
        $date->format('H:i:s', array('timezone' => 'UTC'));
    }
  }

  function getD6body() {
    return isset($this->d6->body) ? $this->d6->body : '';
  }

  function getD6Deltas($field) {
    if (isset($this->d6->{$field}) && (is_array($this->d6->{$field}) || is_object($this->d6->{$field}))) {
      $array = (array) ($this->d6->{$field});
      return array_keys($array);
    }
    else {
      return array();
    }
  }

  function getD6($field, $delta = 0, $key = 'value') {
    return isset($this->d6->{$field}[$delta]->$key) ? $this->d6->{$field}[$delta]->$key : '';
  }

  function log($string) {
    $this->node_processor->log($string);
  }

  function deleteFieldValues($name) {
    $this->d8->set($name, NULL);
  }

  public function process() {
    $this->run();
    return $this->d8;
  }

  public function run() {
    // Do nothing, subclasses will override.
  }

}
