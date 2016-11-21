#/bin/bash
#
# Executes a command on a container.
#
# Pass 'no-exec' as a THIRD argument to simulate what would happen on a
# Docker environment with an LXC driver which does not support exec.
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

if [ "$3" == 'no-exec' ]; then
  echo '[notice] Simulating en environment where docker exec is not supported.'
fi

if [ $(lxc-attach 2>/dev/null >/dev/null) ] || [ "$3" == 'no-exec' ]; then
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
else
  # Docker-compose exec is not reliable, use docker exec instead.
  # https://github.com/docker/compose/issues/3379
  docker exec "$CONTAINER" /bin/bash -c "$COMMAND"
fi
