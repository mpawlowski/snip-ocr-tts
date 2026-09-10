#!/bin/bash

set -eu

# Default values
SAVE=false
SAVE_DIR="/tmp/snip-ocr-tts"

show_help() {
    cat <<EOF
Usage: ${0##*/} [OPTIONS]

Capture a screenshot of a selected area of the screen, extract text using OCR, and read it aloud.

Options:
  --save-dir DIR             Set the directory where the screenshot is saved.
  --help                     Show this help message and exit.
EOF
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --save-dir=*)
            SAVE=true
            SAVE_DIR="${1#*=}"
            shift
            ;;
        --save-dir)
            shift
            SAVE=true
            SAVE_DIR="$1"
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Try '${0##*/} --help' for more information."
            exit 1
            ;;
    esac
done

mkdir -p "$SAVE_DIR"
TMP_OCR_SCREENSHOT="$SAVE_DIR/ocr_screenshot.png"

# Capture an Area
if ! gnome-screenshot -a -f "$TMP_OCR_SCREENSHOT"; then
    echo "Selection cancelled"
    exit 1
fi

# OCR with Tesseract
TEXT=$(tesseract "$TMP_OCR_SCREENSHOT" stdout 2>/dev/null)

# Clean up
rm -f "$TMP_OCR_SCREENSHOT"

# Read aloud
if [ -n "$TEXT" ]; then
    echo "$TEXT" | RHVoice-test -p slt -r 120 -q 3
else
    echo "No text detected."
fi

