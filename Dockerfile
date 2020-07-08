FROM mono:slim
LABEL maintainer="saejinmh@gmail.com"

RUN set -ex && \
  mkdir -p /opt/ckan /kerbal && \
  curl -Lo /opt/ckan/ckan.exe https://github.com/KSP-CKAN/CKAN/releases/latest/download/ckan.exe && \
  echo 'mono /opt/ckan/ckan.exe $@' > /usr/local/bin/ckan && \
  chmod +x /usr/local/bin/ckan && \
  echo 'ckan ksp add default-kerbal /kerbal/' >> /etc/bash.bashrc && \
  echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc && \
  echo "\
====================================================================\n\
= The Comprehensive Kerbal Archive Network (CKAN) Docker Container =\n\
====================================================================\n\
\n\
Using CKAN version $(ckan version)\n\
Ensure your KSP directory is mounted to /kerbal;\n\
This can be done by adding this docker argument:\n\
--mount type=bind,source=/path/to/ksp/directory,target=/kerbal\n\
\n\
GUI commands require x11docker or an exposed X-Server.\n\
Execute ckan commands against the mounted KSP directory by\n\
issuing 'ckan' followed by your ckan arguments.\n" > /etc/motd

CMD ["/bin/bash"]
