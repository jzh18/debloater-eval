#!/usr/bin/env bash

# ----- Common functionality
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
# shellcheck source=lib/core.sh
source "${SCRIPT_DIR}/core.sh"

# ----- Defaults
DEFAULT_BMP_IMG="${SCRIPT_DIR}/../inputs/imagemagick/eggs.bmp"
DEFAULT_GIF_IMG="${SCRIPT_DIR}/../inputs/imagemagick/eggs.gif"
DEFAULT_JPG_IMG="${SCRIPT_DIR}/../inputs/imagemagick/eggs.jpg"
DEFAULT_PNG_IMG="${SCRIPT_DIR}/../inputs/imagemagick/eggs.png"

# ----- Input variables for benchmarking
: "${BIN:=$(which convert)}"
: "${BMP_IMG:=${DEFAULT_BMP_IMG}}"
: "${GIF_IMG:=${DEFAULT_GIF_IMG}}"
: "${JPG_IMG:=${DEFAULT_JPG_IMG}}"
: "${PNG_IMG:=${DEFAULT_PNG_IMG}}"

# ---- Helpers
function _assert_exists {
	file_exists "${1}" || die "Could not find file '${1}'"
}

# ----- Benchmarking functions

function aggressive_flip {
	if [ "${CUT_ARGS}" = true ]; then
		debug "Flip (aggressive) (cut args)"
		flush
		"${BIN}" "${JPG_IMG}" "${JPG_IMG}-flipped.jpg"
	else
		debug "Flip (aggressive)"
		flush
		"${BIN}" "${JPG_IMG}" -flip "${JPG_IMG}-flipped.jpg"
	fi
}

function convert-format {
	debug "Converting"
	flush
	"${BIN}" "${BMP_IMG}" "${BMP_IMG}.gif"
	flush
	"${BIN}" "${BMP_IMG}" "${BMP_IMG}.jpg"
	flush
	"${BIN}" "${BMP_IMG}" "${BMP_IMG}.png"

	flush
	"${BIN}" "${GIF_IMG}" "${GIF_IMG}.bmp"
	flush
	"${BIN}" "${GIF_IMG}" "${GIF_IMG}.jpg"
	flush
	"${BIN}" "${GIF_IMG}" "${GIF_IMG}.png"

	flush
	"${BIN}" "${JPG_IMG}" "${JPG_IMG}.bmp"
	flush
	"${BIN}" "${JPG_IMG}" "${JPG_IMG}.gif"
	flush
	"${BIN}" "${JPG_IMG}" "${JPG_IMG}.png"

	flush
	"${BIN}" "${PNG_IMG}" "${PNG_IMG}.bmp"
	flush
	"${BIN}" "${PNG_IMG}" "${PNG_IMG}.gif"
	flush
	"${BIN}" "${PNG_IMG}" "${PNG_IMG}.jpg"
}

function resize {
	debug "Resizing"
	flush
	"${BIN}" "${JPG_IMG}" -resize "50%" "${JPG_IMG}-resized50.jpg"
	flush
	"${BIN}" "${JPG_IMG}" -resize "150%" "${JPG_IMG}-resized150.jpg"
}

function flip {
	debug "Flip"
	flush
	"${BIN}" "${JPG_IMG}" -flip "${JPG_IMG}-flipped.jpg"
}

function flop {
	debug "Flop"
	flush
	"${BIN}" "${JPG_IMG}" -flop "${JPG_IMG}-flopped.jpg"
}

function negate {
	debug "Negate"
	flush
	"${BIN}" "${JPG_IMG}" -negate "${JPG_IMG}-negate.jpg"
	flush
	"${BIN}" "${JPG_IMG}" +negate "${JPG_IMG}+negate.jpg"
}

function scale {
	debug "Scale"
	flush
	"${BIN}" "${JPG_IMG}" -scale "50%" "${JPG_IMG}-scaled50.jpg"
	flush
	"${BIN}" "${JPG_IMG}" -scale "150%" "${JPG_IMG}-scaled150.jpg"
}

function roll {
	debug "Roll"
	flush
	"${BIN}" "${JPG_IMG}" -roll "+0-270" "${JPG_IMG}-roll+0-270.jpg"
	flush
	"${BIN}" "${JPG_IMG}" -roll "-270-270" "${JPG_IMG}-roll-270-270.jpg"
	flush
	"${BIN}" "${JPG_IMG}" -roll "-270+0" "${JPG_IMG}-roll-270+0.jpg"
	flush
	"${BIN}" "${JPG_IMG}" -roll "+270+0" "${JPG_IMG}-roll+270+0.jpg"
	flush
	"${BIN}" "${JPG_IMG}" -roll "+270+270" "${JPG_IMG}-roll+270+270.jpg"
}

function transverse {
	debug "Transverse"
	flush
	"${BIN}" "${JPG_IMG}" -transverse "${JPG_IMG}-transverse.jpg"
}

function transpose {
	debug "Transpose"
	flush
	"${BIN}" "${JPG_IMG}" -transpose "${JPG_IMG}-transpose.jpg"
}

function rotate {
	debug "Rotate"
	flush
	"${BIN}" "${JPG_IMG}" -rotate 0 "${JPG_IMG}-rotate0.jpg"
	flush
	"${BIN}" "${JPG_IMG}" -rotate -270 "${JPG_IMG}-rotate-270.jpg"
	flush
	"${BIN}" "${JPG_IMG}" -rotate -90 "${JPG_IMG}-rotate-90.jpg"
	flush
	"${BIN}" "${JPG_IMG}" -rotate 90 "${JPG_IMG}-rotate90.jpg"
	flush
	"${BIN}" "${JPG_IMG}" -rotate 270 "${JPG_IMG}-rotate270.jpg"
	flush
	"${BIN}" "${JPG_IMG}" -rotate 360 "${JPG_IMG}-rotate360.jpg"
}

function crop {
	debug "Crop"
	flush
	"${BIN}" "${JPG_IMG}" -crop "123x100+0+90" "${JPG_IMG}-rotate123x100+0+90.jpg"
	flush
	"${BIN}" "${JPG_IMG}" -crop "100x123+90+90" "${JPG_IMG}-rotate100x123+90+90.jpg"
	flush
	"${BIN}" "${JPG_IMG}" -crop "234x123+90+0" "${JPG_IMG}-rotate234x123+90+0.jpg"
	flush
	"${BIN}" "${JPG_IMG}" -crop "50x234+0+0" "${JPG_IMG}-rotate50x234+0+0.jpg"
}
