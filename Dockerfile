FROM mono:6.8
LABEL maintainer="saejinmh@gmail.com"

COPY motd /etc/motd

# Install packages
RUN set -ex && \
  apt-get update -qq && \
  apt-get install -qq wget && \
  rm -rf /var/lib/apt/lists/*

# Install CKAN
RUN set -ex && \
  mkdir -p /opt/ckan /kerbal && \
  wget -qO /opt/ckan/ckan.exe https://github.com/KSP-CKAN/CKAN/releases/latest/download/ckan.exe && \
  echo 'mono /opt/ckan/ckan.exe $@' > /usr/local/bin/ckan && \
  chmod +x /usr/local/bin/ckan && \
  echo "alias update-ckan='wget -O /opt/ckan/ckan.exe https://github.com/KSP-CKAN/CKAN/releases/latest/download/ckan.exe'" >> /etc/bash.bashrc && \
  echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc && \
  echo 'echo "Using CKAN version $(ckan version)"' >> /etc/bash.bashrc && \
  echo "ckan ksp add default-kerbal /kerbal/" >> /etc/bash.bashrc

VOLUME /kerbal
WORKDIR /kerbal


CMD ["/bin/bash"]
