#!/bin/sh
set -eu

# Replace the positional arguments for this script with the Pi extension
# sources.
set -- \
	"npm:cache-warm@0.2.0" \
	"npm:@gotgenes/pi-subagents@19.3.2" \
	"npm:@tmustier/pi-usage-extension@0.9.4" \
	"npm:@vanillagreen/pi-tool-renderer@1.7.1"

for extension in "$@"; do
	pi install "$extension"
done
