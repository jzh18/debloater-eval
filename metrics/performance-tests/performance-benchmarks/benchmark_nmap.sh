#!/usr/bin/env bash

set -euo pipefail

source "lib/nmap.sh"

DEFAULT_BIN="${BIN}"

# ----- Input variables for benchmarking
BIN="${1:-${BIN}}"
: "${TIMES:=5}"

function usage {
	echo "usage: ${0} [<nmap_binary_path>]"
	echo ""
	echo "Default nmap path: '${DEFAULT_BIN}'"
	echo ""
	echo "Optional environment variables to set:"
	echo "    'TIMES': Number of times to run the scenario (${TIMES})"
	echo "  'VERBOSE': Print progress (${VERBOSE})"
}

if [[ "${1:-}" == "-h" ]]; then
	usage
	exit 0
fi

function scenario {
	flush
	tcp_scan
	flush
	tcp_scan_range
	flush
	service_scan
	flush
	service_scan_grep_output
	flush
	service_scan_normal_output
	flush
	service_scan_xml_output
}

for round in $(seq "${TIMES}"); do
	debug "Round ${round}/${TIMES}"
	scenario
done
