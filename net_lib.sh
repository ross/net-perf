#!/bin/bash -e

function status {
  >&2 echo $1
}

SSH_OPTS='-l ubuntu -t -t'
SERVER_PID=
function start_server {
  local host=$1
  local cmd=$2

  # make sure it's not running
  kill_server

  status "starting server: $cmd"
  ssh $SSH_OPTS $host "$cmd" > /dev/null &
  SERVER_PID=$!

  # TODO: cleaner way to wait for server to come up
  sleep 5 
}

function kill_server {
  if [ ! -z "$SERVER_PID" ]; then
    status "killing server: $SERVER_PID"
    kill $SERVER_PID
    status "waiting for server: $SERVER_PID"
    wait $SERVER_PID || true
  fi
  SERVER_PID=
}

function run {
  local label=$1
  local scenario=$2
  local host=$3
  local cmd=$4

  status "running: $cmd"
  ssh $SSH_OPTS $host "$cmd" | sed "s/^/$label,$scenario,/"
}
