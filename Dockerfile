FROM mono:6.8
LABEL maintainer="saejinmh@gmail.com"

VOLUME /kerbal
WORKDIR /kerbal

# Install packages
RUN set -ex && \
  apt-get update -qq && \
  apt-get install -qq wget sudo libgtk2.0-bin && \
  rm -rf /var/lib/apt/lists/*

COPY motd /etc/motd
COPY entry.sh /etc/entry.sh

# Install CKAN
RUN set -ex && \
  mkdir -p /opt/ckan /kerbal && \
  wget -qO /opt/ckan/ckan.exe https://github.com/KSP-CKAN/CKAN/releases/latest/download/ckan.exe && \
  echo 'mono /opt/ckan/ckan.exe $@' > /usr/local/bin/ckan && \
  chmod +x /usr/local/bin/ckan && \
  chmod +x /etc/entry.sh && \
  echo "alias update-ckan='wget -O /opt/ckan/ckan.exe https://github.com/KSP-CKAN/CKAN/releases/latest/download/ckan.exe'" >> /etc/bash.bashrc


ENTRYPOINT ["/etc/entry.sh"]

CMD ["bash"]
