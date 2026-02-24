#!/bin/bash

# go to the script directory
ROOT_DIR=$(dirname "${0}")
cd ${ROOT_DIR}

# help message
function display_help() {
  echo "${0} [--help]"
  echo "  --on                               enable-blackfire"
  echo "  --off                              disable-blackfire"
  echo "  --server-id  <server-id>           blackfire server id (can be defined by env vars)"
  echo "  --server-token <server-token>      blackfire server token (can be defined by env vars)"
  echo
  echo "  Ex:"
  echo "  ${0} --on"
  echo "  ${0} --off"
  echo "  ${0} --on --server-id 1234567890abcde --server-token 1234567890abcde"
}

while test $# -gt 0; do
  _key="$1"
  case "$_key" in
  --help)
    display_help
    exit 0
    ;;
  --on)
    ACTION="ON"
    ;;
  --off)
    ACTION="OFF"
    ;;
  --server-id)
    BLACKFIRE_SERVER_ID=$2
    shift
    ;;
  --server-token)
    BLACKFIRE_SERVER_TOKEN=$2
    shift
    ;;
  esac
  shift
done

if [[ $ACTION == "ON" ]]; then
  if [ -z $BLACKFIRE_SERVER_ID ] || [ -z $BLACKFIRE_SERVER_TOKEN ] || [ -z $BLACKFIRE_CLIENT_ID ] || [ -z $BLACKFIRE_CLIENT_TOKEN ]; then
    echo "BLACKFIRE_SERVER_ID and BLACKFIRE_SERVER_TOKEN must be set (for example in the environment part of a docker-compose.yml file)"
    display_help
    exit 1
  fi

  wget -q -O - https://packages.blackfire.io/gpg.key | dd of=/usr/share/keyrings/blackfire-archive-keyring.asc
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/blackfire-archive-keyring.asc] http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list

  apt-get -qqq update && DEBIAN_FRONTEND=noninteractive apt-get install -qqq -y blackfire

  blackfire agent:config --server-id=${BLACKFIRE_SERVER_ID} --server-token=${BLACKFIRE_SERVER_TOKEN}
  service blackfire-agent restart

  apt-get install -qqq -y blackfire-php
  supervisorctl restart php-fpm


  blackfire client:config --client-id=${BLACKFIRE_CLIENT_ID} --client-token=${BLACKFIRE_CLIENT_TOKEN}
  exit 0
fi

if [[ $ACTION == "OFF" ]]; then
  service blackfire-agent stop
  killall blackfire
  exit 0
fi

echo "Invalid action"
display_help
exit 1
