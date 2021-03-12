#!/usr/bin/env bash

set -e

docker_file="docker/dockerfiles/fairspace-ros2-foxy-nvidia.dockerfile"
image_name="ros2-foxy-rviz-test"

echo $(pwd)
echo ${docker_file}
echo ${image_name}
docker_args="-f $docker_file  --tag=$image_name ."

echo "Building container:"
echo "> docker build $docker_args"
docker build $docker_args