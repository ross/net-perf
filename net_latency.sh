#!/bin/bash -e

source net_lib.sh

LABEL=$1
HOST_A=$2
HOST_B=$3

cmd="sudo mtr --report-wide --interval 0.01 --report-cycles=3000 $HOST_A --order \"D R S B A W V M X I\" --no-dns"
cmd="$cmd | tail -n 1 | sed 's/  1\.|-- [[:digit:]\.]\+\s\+//' | sed 's/ \+/,/g'"

run "$LABEL" "MTR" $HOST_B "$cmd"
