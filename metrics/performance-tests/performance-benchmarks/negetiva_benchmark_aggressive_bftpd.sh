#!/usr/bin/env bash

set -euo pipefail

source "lib/bftpd.sh"

DEFAULT_BIN="${BIN}"

# ----- Input variables for benchmarking
BIN="${1:-${BIN}}"
: "${TIMES:=100}"

function usage {
	echo "usage: ${0} [<bftpd_binary_path>]"
	echo ""
	echo "Default bftpd path: '${DEFAULT_BIN}'"
	echo ""
	echo "Optional environment variables to set:"
	echo "            'CLIENT': Client to execute commands for the server (${CLIENT})"
	echo "             'TIMES': Number of times to run the scenario (${TIMES})"
	echo "  'SERVER_DENY_CONF': Path to server configuration under test (${SERVER_DENY_CONF})"
	echo "       'CLIENT_CONF': Path to client configuration under test (${CLIENT_CONF})"
	echo "           'VERBOSE': Print progress (${VERBOSE})"
}

if [[ "${1:-}" == "-h" ]]; then
	usage
	exit 0
fi

function scenario {
	c_aggressive
}

function start_aggressive_server_container {
	_assert_exists "${SERVER_DENY_CONF}"
	if [ "${CUT_ARGS}" = true ]; then
		debug "Starting server (aggressive) (cut args)"
		pushd "$(dirname "${SERVER_DENY_CONF}")" || exit
		eval "${DOCKER_PREFIX}" "$1" "${BIN}" &
		SERVER_PID=$!
		popd || exit
	else
		debug "Starting server (aggressive)"
		eval "${DOCKER_PREFIX}" "$1" "${BIN}" -D -c "${SERVER_DENY_CONF}" &
		SERVER_PID=$!
	fi
}

function cleanup_container {
	eval docker stop "${CONTAINER_NAME}"
}

# Cleanup if this script dies for some reason
trap "cleanup" SIGINT SIGTERM EXIT

start_aggressive_server_container $2
sleep 0.3

for round in $(seq "${TIMES}"); do
	debug "Round ${round}/${TIMES}"
	scenario
done

cleanup_container
