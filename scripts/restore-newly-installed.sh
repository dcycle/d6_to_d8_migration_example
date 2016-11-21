#!/bin/bash
#
# Restore Drupal 8 as it was when it was newly installed.
#
# Pass 'no-exec' as an argument to simulate what would happen on a
# Docker environment with an LXC driver which does not support exec.
#
set -e

./scripts/exec.sh drupal8 '/restore-newly-installed.sh' "$1"
