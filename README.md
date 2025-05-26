# snip-ocr-tts

A tool which snips text from the screen and reads it aloud.

 Works on Linux.

## Prerequisites

    sudo apt install flameshot tesseract-ocr rhvoice


## Installation

Clone this repository:

    git clone https://github.com/mpawlowski/snip-ocr-tts.git

Add shortcuts (Keyboard / Mouse / Other Device) for the following scripts, or just run them directly.

- `bin/start-snip-ocr-tts.sh` - Select a section of the screen with text to read it aloud.
- `bin/stop-tts.sh` - Stop all text to speech currently running.

## Advanced Usage

### Saving Screenshots

To save screenshots you snip, use `--save-dir` option:

    ./bin/start-snip-ocr-tts.sh --save-dir ~/Pictures/screenshots

### Stopping Desktop Notifications

If you don't want to see flameshot desktop notifications, you can configure it in the gui by running `flameshot` directly, or by editing the config file:

    ~/.config/flameshot/config.ini


Create the file or add/change the following setting:

    [General]
    showDesktopNotification=false

## Limitations

### Linux Only

Tested on `Ubuntu 20.04` with `X11`, but should work on other distributions as well.

### No Fullscreen

Fullscreen applications don't work. Feel free to PR and fix.
