
FROM bodsch/docker-alpine-base:1701-04

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version="1.6.0"

ENV TERM xterm

EXPOSE 5665 6666

# ---------------------------------------------------------------------------------------

RUN \
  apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add \
    build-base \
    ruby \
    ruby-dev \
    drill \
    bind-tools \
    pwgen \
    fping \
    unzip \
    netcat-openbsd \
    nmap \
    bc \
    jq \
    yajl-tools \
    ssmtp \
    mailx \
    mysql-client \
    icinga2 \
    openssl \
    monitoring-plugins \
    nrpe-plugin && \
  gem install --no-rdoc --no-ri \
    dalli \
    sequel \
    ipaddress \
    json \
    time_difference \
    bigdecimal && \
  cp /etc/icinga2/conf.d.example/* /etc/icinga2/conf.d/ && \
  cp /usr/lib/nagios/plugins/*     /usr/lib/monitoring-plugins/ && \
  /usr/sbin/icinga2 feature enable command livestatus compatlog checker mainlog && \
  mkdir -p /run/icinga2/cmd && \
  chmod u+s /bin/busybox && \
  apk del --purge \
    build-base \
    bash \
    curl \
    nano \
    tree \
    ruby-dev \
    git && \
  rm -rf \
    /tmp/* \
    /var/cache/apk/*

COPY rootfs/ /

VOLUME [ "/etc/icinga2", "/var/lib/icinga2", "/run/icinga2/cmd" ]

CMD [ "/opt/startup.sh" ]

# ---------------------------------------------------------------------------------------
