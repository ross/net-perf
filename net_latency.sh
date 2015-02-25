#!/bin/bash -e

source net_lib.sh

LABEL=$1
HOST_A=$2
HOST_B=$3
DURATION=$4
BANDWIDTHS=$5
SIZES=$6

run "$LABEL" "MTR" $HOST_B "sudo mtr --report-wide 10 --interval 0.01 --report-cycles=100 $HOST_A --order \"D R S B A W V M X I\" --csv --no-dns | head -n 1"
