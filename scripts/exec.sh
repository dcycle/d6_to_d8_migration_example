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

if [ $(lxc-attach 2>/dev/null >/dev/null) ]; then
  # The LXC driver does not support exec, see
  # https://circleci.com/docs/docker/#docker-exec
  sudo lxc-attach -n \
    "$(docker inspect --format "{{.Id}}" "$CONTAINER")" \
    -- bash -c "$COMMAND"
else
  # Docker-compose exec is not reliable, use docker exec instead.
  # https://github.com/docker/compose/issues/3379
  docker exec "$CONTAINER" /bin/bash -c "$COMMAND"
fi
