#!/bin/bash
#
# Kill the Docker development environment.
#

rm -rf ./workspace/workspace/*
docker-compose kill
docker-compose rm -f
