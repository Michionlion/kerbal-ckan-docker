#!/bin/bash

# print MOTD
if [ ! -z "$TERM" -a -r /etc/motd ]; then
  cat /etc/motd
  echo ""
fi

# Print version info
echo ">>> Using CKAN version $(ckan version)"

echo ">>> Setting up..."

buildID=$(find / \
  -not \( -path /proc -prune \) \
  -not \( -path /usr -prune \) \
  -not \( -path /var -prune \) \
  -not \( -path /etc -prune \) \
  -not \( -path /root -prune \) \
  -name buildID.txt | head -n 1)

if [ -z "$buildID" ]; then
  echo "No buildID.txt found, did you mount your KSP directory?"
  echo "Use '--mount type=bind,source=<KSP_PATH>,target=/kerbal' in"
  echo "your 'docker run' command, and replace <KSP_PATH>."
  echo ""
  echo "'ckan' is still available, but you will have no KSP to work with."
  exec_user=root
else
  kerbal=$(dirname "$buildID")
  
  echo "Found $buildID, using $kerbal as KSP directory"

  gid=$(stat -c '%g' "$kerbal/GameData")
  uid=$(stat -c '%u' "$kerbal/GameData")

  if [ "$UID" != "$uid" ]; then
    groupadd -g $gid user
    useradd -mN -g $gid -u $uid user
  fi
  if [ "$UID" != "0" ]; then
    echo "Container started with non-root user, ckan-update will be unavailable."
  else
    # Enable changing ckan install directory
    chown -R $uid:$gid /opt/ckan
  fi

  # Set up mounted ksp
  if [ "$UID" != "$uid" ]; then
    sudo -u user -i << EOF
      ckan ksp add mounted-ksp $kerbal
      ckan ksp default mounted-ksp
EOF
  else
    ckan ksp add mounted-ksp $kerbal
    ckan ksp default mounted-ksp
  fi
  exec_user=user
fi
echo ">>> Ready!"

echo ">>> Starting '$@'..."
# pass on execution to whatever this was called with
# must use sudo (not su) to preserve tty if switching user
if [ "$UID" = "0" ]; then
  sudo -u $exec_user "$@"
else
  exec "$@"
fi
