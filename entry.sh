#!/bin/bash

# print MOTD
if [ ! -z "$TERM" -a -r /etc/motd ]; then
  cat /etc/motd
  echo ""
fi

# Print version info
echo ">>> Using CKAN version $(ckan version)"

echo ">>> Setting up..."

readarray -d '' buildIDs < <(find / \
  -not \( -path /proc -prune \) \
  -not \( -path /usr -prune \) \
  -not \( -path /var -prune \) \
  -not \( -path /etc -prune \) \
  -not \( -path /root -prune \) \
  -not \( -path /run -prune \) \
  -not \( -path /tmp -prune \) \
  -not \( -path /sys -prune \) \
  -not \( -path /dev -prune \) \
  -name buildID.txt -print0)

for i in "${!buildIDs[@]}"; do
  buildIDs[$i]=$(dirname ${buildIDs[$i]})
done

PS3="#? "
kerbal="";
if ((${#buildIDs[@]}==1)); then
  kerbal=${buildIDs[0]}
else
  echo "Choose which KSP directory to use as the default:"
  select file in "${buildIDs[@]}"; do
    kerbal=$file
    break
  done
fi

if [ -z "$kerbal" ]; then
  echo "No buildID.txt found, did you mount your KSP directory?"
  echo "Use '--mount type=bind,source=<KSP_PATH>,target=/kerbal' in"
  echo "your 'docker run' command, and replace <KSP_PATH>."
  echo ""
  echo "'ckan' is still available, but you will have no KSP to work with."
  exec_user=root
else
  echo "Using $kerbal as default KSP directory"

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
