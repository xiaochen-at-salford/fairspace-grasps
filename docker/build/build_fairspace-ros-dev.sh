#!/usr/bin/env bash

set -e

docker_file="docker/dockerfiles/farispace-ros-melodic-ubuntu18.04.dockerfile"
image_name="fairspace-ros-dev-melodic-ubuntu18.04"

echo $(pwd)
echo ${docker_file}
echo ${image_name}
docker_args="-f $docker_file  --tag=$image_name ."

echo "Building container:"
echo "> docker build $docker_args"
docker build $docker_args