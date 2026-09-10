# snip-ocr-tts

A tool which snips text from the screen and reads it aloud.

 Works on Linux.

## Prerequisites

    sudo apt install gnome-screenshot tesseract-ocr rhvoice


## Installation

Clone this repository:

    git clone https://github.com/mpawlowski/snip-ocr-tts.git

Add shortcuts (Keyboard / Mouse / Other Device) for the following scripts, or just run them directly.

- `bin/start-snip-ocr-tts.sh` - Select a section of the screen with text to read it aloud.
- `bin/stop-tts.sh` - Stop all text to speech currently running.

### Nix

A [flake](flake.nix) is provided which supplies `gnome-screenshot`, `tesseract`, and `rhvoice` and wraps both scripts with them.

Run without installing:

    nix run github:mpawlowski/snip-ocr-tts#start
    nix run github:mpawlowski/snip-ocr-tts#stop

Install into your profile (recommended for keyboard shortcuts, so the commands have stable paths):

    nix profile install github:mpawlowski/snip-ocr-tts

Then bind shortcuts to:

    ~/.nix-profile/bin/start-snip-ocr-tts
    ~/.nix-profile/bin/stop-tts

For development, drop into a shell with the dependencies on `PATH`:

    nix develop

From a local clone, use `nix run .#start`, `nix run .#stop`, or `nix profile install .` instead.

## Advanced Usage

### Saving Screenshots

To save screenshots you snip, use `--save-dir` option:

    ./bin/start-snip-ocr-tts.sh --save-dir ~/Pictures/screenshots

## Limitations

### Linux Only

Tested on `Ubuntu 24.04.2 LTS` with `X11`, but should work on other distributions as well.

### No Fullscreen

Fullscreen applications don't work. Feel free to PR and fix.
