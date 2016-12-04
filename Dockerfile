
FROM bodsch/docker-alpine-base:alpine-3.5

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
    git \
    boost-dev \
    libressl-dev \
    yajl-dev \
    libedit-dev \
    libcap-dev \
    bison \
    flex-dev \
    mariadb-dev \
    cmake \
    shadow && \
  groupadd icinga && \
  groupadd icingacmd && \
  useradd -c "icinga" -s /sbin/nologin -G icingacmd -g icinga icinga && \
  cd /opt && \
  git clone https://github.com/Icinga/icinga2.git && \
  cd /opt/icinga2 && \
  mkdir build && \
  cd build && \
  cmake .. \
    -DCMAKE_VERBOSE_MAKEFILE=OFF \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_INSTALL_SYSCONFDIR=/etc \
    -DCMAKE_INSTALL_LOCALSTATEDIR=/var \
    -DINSTALL_SYSTEMD_SERVICE_AND_INITSCRIPT=OFF \
    -DICINGA2_SYSCONFIGFILE=/etc/conf.d/icinga2 \
    -DICINGA2_GIT_VERSION_INFO=ON \
    -DICINGA2_RUNDIR=/run \
    -DICINGA2_UNITY_BUILD=ON \
    -DICINGA2_LTO_BUILD=ON \
    -DICINGA2_WITH_PGSQL=OFF \
    -DICINGA2_WITH_COMPAT=OFF \
    -DICINGA2_WITH_STUDIO=OFF \
    -DICINGA2_WITH_TESTS=OFF && \
  make && \
  make install && \
  cp -ar /opt/icinga2/etc/icinga2 /etc && \
  find /etc/icinga2 -name "*cmake*" -delete && \
  rm -rf /etc/icinga2/win32 && \
  for d in command livestatus compatlog checker mainlog; do cp -v /opt/icinga2/etc/icinga2/features-available/${d}.conf   /etc/icinga2/features-available/${d}.conf ; done && \
  /usr/sbin/icinga2 feature enable command livestatus compatlog checker mainlog && \
  mkdir -p /run/icinga2/cmd && \
  apk --no-cache add \
    ruby \
    ruby-dev \
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
    openssl \
    monitoring-plugins \
    nrpe-plugin && \
  gem install --no-rdoc --no-ri \
    dalli \
    json \
    time_difference \
    bigdecimal && \
  cp -v /usr/lib/nagios/plugins/*     /usr/lib/monitoring-plugins/ && \
  chmod u+s /bin/busybox && \
  apk del --purge \
    build-base \
    git \
    boost-dev \
    libressl-dev \
    yajl-dev \
    libedit-dev \
    libcap-dev \
    bison \
    flex-dev \
    mariadb-dev \
    cmake \
    shadow \
    ruby-dev && \
  rm -rf \
    /opt/icinga2 \
    /tmp/* \
    /var/cache/apk/*

COPY rootfs/ /
VOLUME [ "/etc/icinga2", "/var/lib/icinga2", "/run/icinga2/cmd" ]

CMD /opt/startup.sh

# ---------------------------------------------------------------------------------------
