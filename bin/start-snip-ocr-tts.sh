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

# Create save directory for temporary file
mkdir -p "$SAVE_DIR"
TMP_OCR_SCREENSHOT="$SAVE_DIR/ocr_screenshot.png"

# Build flameshot command arguments
flameshot_args=(gui -s -r)
if [ "$SAVE" = true ]; then
    flameshot_args+=(-p "$SAVE_DIR")
fi

# Run flameshot and capture the screenshot to temp file
flameshot "${flameshot_args[@]}" > "$TMP_OCR_SCREENSHOT"

# OCR with Tesseract
TEXT=$(tesseract "$TMP_OCR_SCREENSHOT" stdout 2>/dev/null)

# Always delete the temporary screenshot
rm -f "$TMP_OCR_SCREENSHOT"

# Read aloud
echo "$TEXT" | RHVoice-test -p slt -r 120 -q 3
