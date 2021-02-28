#!/usr/bin/env bash

function _create_user_account() 
{
  local user_name="$1"
  local uid="$2"
  local group_name="$3"
  local gid="$4"
  addgroup --gid "${gid}" "${group_name}"

  adduser --disabled-password --force-badname --gecos '' \
    "${user_name}" --uid "${uid}" --gid "${gid}" # 2>/dev/null

  usermod -aG sudo "${user_name}"
  usermod -aG video "${user_name}"
}

function setup_user_bashrc() 
{
  local uid="$1"
  local gid="$2"
  local user_home="/home/$3"
  # cp -rf /etc/skel/.{profile,bash*} "${user_home}"
  local RCFILES_DIR="/opt/fairspace/rcfiles"
  local rc
  if [[ -d "${RCFILES_DIR}" ]]; 
  then
    for entry in ${RCFILES_DIR}/*; 
    do
      rc=$(basename "${entry}")
      if [[ "${rc}" = user.* ]]; 
      then
        cp -rf "${entry}" "${user_home}/${rc##user}"
      fi
    done
  fi
  # Set user files ownership to current user, such as .bashrc, .profile, etc.
  # chown -R "${uid}:${gid}" "${user_home}"
  chown -R "${uid}:${gid}" ${user_home}/.*
}

function setup_user_account_if_not_exist() 
{
  local user_name="$1"
  local uid="$2"
  local group_name="$3"
  local gid="$4"
  if grep -q "^${user_name}:" /etc/passwd; 
  then
    echo "User ${user_name} already exist. Skip setting user account."
    return
  fi
  _create_user_account "$@"
  setup_user_bashrc "${uid}" "${gid}" "${user_name}"
}

function grant_device_permissions() 
{
  [ -e /dev/ttyUSB0 ] && chmod a+rw /dev/ttyUSB0
  [ -e /dev/ttyUSB1 ] && chmod a+rw /dev/ttyUSB1
}

function setup_fairspace_directories() 
{
  local fairspace_dir="/opt/fairspace"
  [[ -d "${fairspace_dir}" ]] || mkdir -p "${fairspace_dir}"
  # chown -R "${uid}:${gid}" "${apollo_dir}"
}

function load_ros2_setups()
{
  local user_name="$1"
  echo "" >> "/home/${user_name}/.bashrc"
  echo "source \"/ros_entrypoint.sh\"" >> "/home/${user_name}/.bashrc"
  echo "source \"/ros2_fs/install/setup.bash\""  >> "/home/${user_name}/.bashrc"

  # fs_ros2_bash="/fairspace/install/setup.bash"
  # if [[ -f "${fs_ros2_bash}" ]];
  # then 
  #     info "Found FAIRSPACE ROS2 workspace"
  #     echo "source \"/fairspace/install/setup.bash\""  >> "/home/${user_name}/.bashrc"
  # fi
}

function main() 
{
  local user_name="$1"
  local uid="$2"
  local group_name="$3"
  local gid="$4"

  if [ "${uid}" != "${gid}" ]; 
  then
    echo "Warning: uid(${uid}) != gid(${gid}) found."
  fi
  if [ "${user_name}" != "${group_name}" ]; 
  then
    echo "Warning: user_name(${user_name}) != group_name(${group_name}) found."
  fi
  setup_user_account_if_not_exist "$@"
  setup_fairspace_directories "${uid}" "${gid}"
  grant_device_permissions "${user_name}"

  load_ros2_setups "${user_name}"
}

main "${DOCKER_USER}" "${DOCKER_USER_ID}" "${DOCKER_GRP}" "${DOCKER_GRP_ID}"
