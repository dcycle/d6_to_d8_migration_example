#/bin/bash
#
# Executes a command on a container.
#
set -e

if [ -z "$1" ]; then
  echo 'Please specify a container name as defined in docker-compose.yml.'
  exit 1
fi
if [ -z "$2" ]; then
  echo 'Please specify the command you would like to execute.'
fi

COMPOSECONTAINER="$1"
CONTAINER="$(docker-compose ps -q "$COMPOSECONTAINER")"
COMMAND="$2"

# The LXC driver does not support exec, see
# https://circleci.com/docs/docker/#docker-exec; the solution suggested in
# the documentation does not work, so we will try a different approach:
# Because Circle uses LXC and does not support exec, we'll use
# our run-drupal8 script instead. Instead of executing a command on an
# existing container (drupal8), run-drupal8.sh will create a new drupal8
# container linked to our database, run a command, and destroy the
# container after
if [ "$COMPOSECONTAINER" == 'drupal8' ]; then
  ./scripts/run-drupal8.sh "$COMMAND"
elif [ "$COMPOSECONTAINER" == 'drupal6' ]; then
  ./scripts/run-drupal6.sh "$COMMAND"
else
  echo "Sorry, you cannot call ./scripts/exec.sh on a container other than"
  echo "drupal8 or drupal6 for the time being."
  exit 1
fi
