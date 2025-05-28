#!/usr/bin/env bash

# ----- Common functionality
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
# shellcheck source=lib/core.sh
source "${SCRIPT_DIR}/core.sh"

# ----- Defaults

# ----- Input variables for benchmarking
: "${BIN:=$(which nmap)}"

# ---- Helpers

# ----- Benchmarking functions

function aggressive_scan {
	if [ "${CUT_ARGS}" = true ]; then
		debug "Scanning (aggressive) (cut args)"
		flush
		"${BIN}"
	else
		debug "Scanning (aggressive)"
		flush
		"${BIN}" -sT -p1-7080,8080 127.0.0.1
	fi
}

function tcp_scan {
	flush
	"${BIN}" -sT 127.0.0.1
}

function tcp_scan_range {
	flush
	"${BIN}" -sT -p1-7080,8080 127.0.0.1
}

function service_scan {
	flush
	"${BIN}" -sT -sV 127.0.0.1
}

function service_scan_grep_output {
	flush
	"${BIN}" -sT -sV -oG report 127.0.0.1
}

function service_scan_normal_output {
	flush
	"${BIN}" -sT -sV -oN report 127.0.0.1
}

function service_scan_xml_output {
	flush
	"${BIN}" -sT -sV -oX report 127.0.0.1
}
