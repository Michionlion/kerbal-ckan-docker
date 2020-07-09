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
  echo "'ckan' is still available, but you will have no KSP to work with."
  exec_user=root
else
  gid=$(stat -c '%g' /kerbal/GameData)
  uid=$(stat -c '%u' /kerbal/GameData)

  groupadd -g $gid user
  useradd -mN -g $gid -u $uid user

  # Enable changing ckan install directory
  chown -R $uid:$gid /opt/ckan

  # Set up mounted ksp
  su user - << EOF
  ckan ksp add mounted-ksp /kerbal
  ckan ksp default mounted-ksp
EOF

  exec_user=user
fi
echo ">>> Ready!"

echo ">>> Starting '$@'..."
# pass on execution to whatever this was called with
# must use sudo (not su) to preserve tty
sudo -u $exec_user "$@"
