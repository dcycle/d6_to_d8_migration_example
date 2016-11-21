#/bin/bash
#
# Runs a command on a throwaway Drupal 8 container.
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

DRUPAL8="$(docker-compose ps -q drupal8)"

UNIQUEIMAGENAME="$DRUPAL8"_image

IMAGE=$(docker images -q "$UNIQUEIMAGENAME" 2>/dev/null)

if [ -z "$IMAGE" ];then
  docker build -f="Dockerfile-drupal8" -t "$UNIQUEIMAGENAME" .
  IMAGE=$(docker images -q "$UNIQUEIMAGENAME")
fi

# See http://stackoverflow.com/questions/36489696
NETWORK=$(docker inspect "$DRUPAL8"|grep NetworkMode|sed 's/^[^"]*"[^"]*"[^"]*"//g'|sed 's/".*$//g')

echo "$DRUPAL8DATABASE"

# We are linking the names of the containers in the context of the network,
# not the absolute container names that we can retrieve via docker ps.
docker run \
  -v "$(pwd)"/docker-resources/drupal6/files:/drupal6code/sites/default/files \
  -v "$(pwd)"/my_migration:/var/www/html/modules/custom/my_migration \
  -v "$(pwd)"/workspace/workspace/drupal8-files:/var/www/html/sites/default/files \
  --link drupal6:drupal6 \
  --link drupal8database:drupal8database \
  --link drupal6database:drupal6database \
  --net "$NETWORK" \
  "$IMAGE" /bin/bash -c "$COMMAND"
