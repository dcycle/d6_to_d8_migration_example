#/bin/bash
#
# Runs a command on a throwaway Drupal 6 container.
# Use this instead of exec, because we want to avoid "polluting" our
# containers with exec, and the LXC driver used by Circle does not support
# exec.
#
set -e

if [ -z "$1" ]; then
  echo 'Please specify a command to run.'
  exit 1
fi
COMMAND="$1"

DRUPAL6="$(docker-compose ps -q drupal6)"

UNIQUEIMAGENAME="$DRUPAL6"_image

IMAGE=$(docker images -q "$UNIQUEIMAGENAME" 2>/dev/null)

if [ -z "$IMAGE" ];then
  docker build -f="Dockerfile-drupal6" -t "$UNIQUEIMAGENAME" .
  IMAGE=$(docker images -q "$UNIQUEIMAGENAME")
fi

# See http://stackoverflow.com/questions/36489696
NETWORK=$(docker inspect "$DRUPAL6"|grep NetworkMode|sed 's/^[^"]*"[^"]*"[^"]*"//g'|sed 's/".*$//g')

# We are linking the names of the containers in the context of the network,
# not the absolute container names that we can retrieve via docker ps.
docker run \
  -v "$(pwd)"/docker-resources/drupal6/db:/db \
  -v "$(pwd)"/docker-resources/drupal6/files:/var/www/html/sites/default/files \
  --link drupal6database:drupal6database \
  --net "$NETWORK" \
  "$IMAGE" /bin/bash -c "$COMMAND"
