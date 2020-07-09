#!/bin/bash

# print MOTD
if [ ! -z "$TERM" -a -r /etc/motd ]; then
  cat /etc/motd
  echo ""
fi

# Print version info
echo ">>> Using CKAN version $(ckan version)"

echo ">>> Setting up..."
if [ -n "$(find /kerbal -prune -empty 2>/dev/null)" ]; then
  echo "No files found in /kerbal, did you mount your KSP directory?"
  echo "Use '--mount type=bind,source=<KSP_PATH>,target=/kerbal' in"
  echo "your 'docker run' command, and replace <KSP_PATH>."
  echo ""
  echo "'ckan' is still available, but will have no KSP to work with."
else
  # Set up mounted ksp
  ckan ksp add mounted-ksp /kerbal
  ckan ksp default mounted-ksp
fi
echo ">>> Ready!"

echo ">>> Starting $@..."

# pass on execution to whatever this was called with
exec "$@"
