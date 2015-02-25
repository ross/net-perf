#!/bin/bash -e
 
HOST=$1
 
ssh $HOST << EOF
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install iperf
EOF
