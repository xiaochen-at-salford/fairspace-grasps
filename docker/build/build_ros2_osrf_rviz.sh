#!/usr/bin/env bash

set -e

docker_file="docker/dockerfiles/osrf_ros2_foxy_rviz.dockerfile"
image_name="osrf-ros2-foxy-rviz"

echo $(pwd)
echo ${docker_file}
echo ${image_name}
docker_args="-f $docker_file  --tag=$image_name ."

echo "Building container:"
echo "> docker build $docker_args"
docker build $docker_args