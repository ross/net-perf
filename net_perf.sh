#!/bin/bash -e

source net_lib.sh

LABEL=$1
HOST_A=$2
HOST_B=$3
DURATION=$4
BANDWIDTHS=$5
SIZES=$6

if [ -z "$DURATION" ]; then
  DURATION=30
fi

if [ -z "$BANDWIDTHS" ]; then
  BANDWIDTHS="128m 512m 1024m 4096m 8192m"
fi

if [ -z "$SIZES" ]; then
  SIZES="512 1024 4096 8192"
fi

# general
# -w tcp window size XM
# -M tcp max seg size (mtu - 40 bytes)
# -l read/write buffer size

# client
# -b udp bandwidth XM
# -n number of bytes to tx
# -t duration in s
# -d bi-directional test simul
# -r ""                " one at a time
# -P parallel threads

OPTS="-y C -i 1 -t $DURATION"

status "TCP"
start_server $HOST_A "iperf -s -p 4321"
run "$LABEL" "TCP" $HOST_B "iperf -c $HOST_A -p 4321 $OPTS" 
kill_server

status "UDP"
start_server $HOST_A "iperf -s -u -p 4321"
for bandwidth in $BANDWIDTHS; do
  for size in $SIZES; do
    run "$LABEL" "UDP $bandwidth $size" $HOST_B "iperf -c $HOST_A -p 4321 -u -b $bandwidth -l $size $OPTS"
  done
done
kill_server
