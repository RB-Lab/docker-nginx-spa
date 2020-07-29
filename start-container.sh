#!/bin/bash

set -e

NGINX_PORT=${NGINX_PORT:-80}

export NGINX_PORT

echo "==> Setting port to ${NGINX_PORT}"

envsubst '${NGINX_PORT}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf


if [[ $CONFIG_VARS ]]; then

  SPLIT=$(echo $CONFIG_VARS | tr "," "\n")
  ARGS=
  for VAR in ${SPLIT}; do
      ARGS="${ARGS} -v ${VAR} "
  done

  JSON=`json_env --json $ARGS`

  echo " ==> Writing ${CONFIG_FILE_PATH}/config.js with ${JSON}"

  echo "window.__env = ${JSON}" > ${CONFIG_FILE_PATH}/config.js
fi

exec "$@"
