#!/usr/bin/env bash

set -e

docker_file="docker/dockerfiles/moveit_melodic_rviz.dockerfile"
image_name="moveit-melodic-rviz-intel"

echo $(pwd)
echo ${docker_file}
echo ${image_name}
docker_args="-f $docker_file  --tag=$image_name ."

echo "Building container:"
echo "> docker build $docker_args"
docker build $docker_args