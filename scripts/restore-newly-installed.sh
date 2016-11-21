#!/bin/bash
#
# Restore Drupal 8 as it was when it was newly installed.
#
set -e

./scripts/exec.sh drupal8 '/restore-newly-installed.sh'
