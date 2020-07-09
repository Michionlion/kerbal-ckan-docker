FROM mono:6.8
LABEL maintainer="saejinmh@gmail.com"

COPY motd /etc/motd
COPY entry.sh /etc/entry.sh

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
  chmod +x /etc/entry.sh && \
  echo "alias update-ckan='wget -O /opt/ckan/ckan.exe https://github.com/KSP-CKAN/CKAN/releases/latest/download/ckan.exe'" >> /etc/bash.bashrc


VOLUME /kerbal
WORKDIR /kerbal

ENTRYPOINT ["/etc/entry.sh"]

CMD [ "bash" ]
