#!/usr/bin/env bash

set -e

docker_file="docker/dockerfiles/fairspace-ros2-foxy-rviz-nvidia.dockerfile"
image_name="fairspace-ros2-foxy-rviz-nvidia"

echo $(pwd)
echo ${docker_file}
echo ${image_name}
docker_args="-f $docker_file  --tag=$image_name ."

echo "Building container:"
echo "> docker build $docker_args"
docker build $docker_args