#!/usr/bin/env bash

# Variables
# Whether to print debug messages
: "${VERBOSE:=true}"
# Whether to remove static arguments (see "Aggressive General debloating specifications")
: "${CUT_ARGS:=false}"

CONTAINER_NAME="tmp"
DOCKER_PREFIX="docker run --rm -i --name ${CONTAINER_NAME}  --privileged  --ulimit core=-1  --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v /home/ubuntu/repos/file_level_bloat/:/home/ubuntu/repos/file_level_bloat --network host -v /tmp:/tmp -e RUST_BACKTRACE=1 -e RUST_LOG=warn -e PATH=/home/ubuntu/miniconda3/bin:/home/ubuntu/miniconda3/condabin:/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin -e LD_LIBRARY_PATH=/home/ubuntu/repos/file_level_bloat/experiment/workloads/repos/debloater-eval/benchmarks/benchmarks/high/imagemagick-7.0.1-0/binaries/64:/home/ubuntu/repos/file_level_bloat/experiment/workloads/repos/debloater-eval/benchmarks/benchmarks/high/poppler-0.60/binaries/64/ -e MAGICK_CONFIGURE_PATH=/home/ubuntu/repos/file_level_bloat/experiment/workloads/repos/debloater-eval/benchmarks/benchmarks/high/imagemagick-7.0.1-0/binaries/64 "

function file_exists {
	test -f "${1}"
}

function die {
	echo >&2 "Fatal:" "${@}"
	exit 1
}

function debug {
	if [ "${VERBOSE}" = true ]; then echo "|" "${1}"; fi
}

function which {
	command which "${1}" 2>/dev/null || echo ""
}

# https://stackoverflow.com/a/21188136
function realpath {
	# $1 : relative filename
	filename=$1
	parentdir=$(dirname "${filename}")

	if [ -d "${filename}" ]; then
		# shellcheck disable=SC2005
		echo "$(cd "${filename}" && pwd)"
	elif [ -d "${parentdir}" ]; then
		echo "$(cd "${parentdir}" && pwd)/$(basename "${filename}")"
	fi
}

function wait_kill {
	if [ "${1}" -ne 0 ]; then
		kill "${1}"
		while kill -0 "${1}" 2>/dev/null; do
			sleep 0.1
		done
	fi
}

