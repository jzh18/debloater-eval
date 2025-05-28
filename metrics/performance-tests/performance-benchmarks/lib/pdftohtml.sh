#!/usr/bin/env bash

# ----- Common functionality
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
# shellcheck source=lib/core.sh
source "${SCRIPT_DIR}/core.sh"

# ----- Defaults
DEFAULT_SIMPLE_INPUT="${SCRIPT_DIR}/../inputs/pdftohtml/markdown.pdf"
DEFAULT_COMPLEX_INPUT="${SCRIPT_DIR}/../inputs/pdftohtml/BinRec.pdf"

# ----- Input variables for benchmarking
: "${BIN:=$(which pdftohtml)}"
: "${SIMPLE_INPUT:=${DEFAULT_SIMPLE_INPUT}}"
: "${COMPLEX_INPUT:=${DEFAULT_COMPLEX_INPUT}}"

# ---- Helpers
function _assert_exists {
	file_exists "${1}" || die "Could not find file '${1}'"
}

# ----- Benchmarking functions

function simple {
	_assert_exists "${SIMPLE_INPUT}"
	debug "Simple PDF"
	flush
	"${BIN}" "${SIMPLE_INPUT}"
}

function opts_range {
	_assert_exists "${SIMPLE_INPUT}"
	debug "Page Range"
	flush
	"${BIN}" -f 1 -l 1 "${SIMPLE_INPUT}"
}

function single_doc {
	_assert_exists "${SIMPLE_INPUT}"
	debug "Single Doc"
	flush
	"${BIN}" -s "${SIMPLE_INPUT}"
}

function complex {
	_assert_exists "${COMPLEX_INPUT}"
	debug "Complex Doc"
	flush
	"${BIN}" "${COMPLEX_INPUT}"
}
