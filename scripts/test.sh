#/bin/bash
#
# Run tests.
#
set -e

# Create the environment.
./scripts/run.sh

# Run the tests.
./scripts/test-existing-container.sh
