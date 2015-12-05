#!/bin/bash

DOCKER_COMPOSE_FILE="/var/www/"${1}"/docker-compose.yml"
PROJECT_ROOT="/var/www/"${1}

php_container_exists() {
  echo "$(cd ${PROJECT_ROOT} && docker-compose -f ${DOCKER_COMPOSE_FILE} ps php 2> /dev/null | grep _php_ | awk '{ print $1 }')"
}

php_container_running() {
  local CONTAINER="${1}"

  echo "$(docker exec ${CONTAINER} date 2> /dev/null)"
}

if [ -z ${1} ] ; then
    echo 'Enter project to start'
else
    if [ -f "$DOCKER_COMPOSE_FILE" ]; then

        CONTAINER="$(php_container_exists)"

        if [ -n "$(php_container_running ${CONTAINER})" ]; then
            echo "Project already running!"
            read -p "Would you like to stop the containers? [Y/n]: " ANSWER
            if [ "${ANSWER}" == "n" ]; then
                exit
            fi

            docker-compose -f "${DOCKER_COMPOSE_FILE}" kill
        else
            docker-compose -f "${DOCKER_COMPOSE_FILE}" up -d
        fi
    else
        echo "folder" ${1} "does not exits or does not contain docker-compose.yml file"
    fi
fi
