<?php

/**
 * Implementation of hook_node_info().
 */
function drupal6structure_node_info() {
  $items = array(
    'legacy_type_one' => array(
      'name' => t('legacy_type_one'),
      'module' => 'features',
      'description' => t('legacy_type_one'),
      'has_title' => '1',
      'title_label' => t('Title'),
      'has_body' => '1',
      'body_label' => t('Body'),
      'min_word_count' => '0',
      'help' => '',
    ),
    'legacy_type_two' => array(
      'name' => t('legacy_type_two'),
      'module' => 'features',
      'description' => t('legacy_type_two'),
      'has_title' => '1',
      'title_label' => t('Title'),
      'has_body' => '1',
      'body_label' => t('Body'),
      'min_word_count' => '0',
      'help' => '',
    ),
  );
  return $items;
}
