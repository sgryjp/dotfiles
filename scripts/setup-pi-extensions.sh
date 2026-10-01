#!/bin/sh
set -eu

# Replace the positional arguments for this script with the Pi extension
# sources.
set -- \
  "npm:cache-warm@0.2.0" \
  "npm:@gotgenes/pi-subagents@21.8.1" \
  "npm:@tmustier/pi-usage-extension@0.9.4" \
  "npm:@vanillagreen/pi-tool-renderer@2.0.9"

for extension in "$@"; do
  pi install "$extension"
done
