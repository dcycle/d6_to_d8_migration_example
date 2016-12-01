<?php

namespace Drupal\my_migration;

class MyMigrationNodeProcessor {

  public function __construct($d6, $d8) {
    $this->d6 = $d6;
    $this->d8 = $d8;
  }

  public function nid() {
    return $this->d6->nid;
  }

  public function process() {
    $this->log('Node type is: ' . get_class($this));
    if ($this->toDelete()) {
      $this->d8->delete();
      return;
    }
    $field_processors = $this->fieldProcessors($this->nid(), $this->d6, $this->d8);
    if (count($field_processors)) {
      foreach ($field_processors as $field_processor) {
        $field_processor->setD8($this->d8);
        $this->log('Running processor ' . get_class($field_processor));
        $this->d8 = $field_processor->process();
      }
    };
    $this->d8->save();
  }

  public function toDelete() {
    return FALSE;
  }

  public function log($string) {
    print_r('[info] Node ' . $this->nid() . ': ' . $string . PHP_EOL);
  }

  protected function fieldProcessors($nid, $d6, $d8) {
    return array();
  }

}
