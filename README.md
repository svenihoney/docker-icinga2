docker-icinga2
==============

Compile and installs an working icinga2 Core or Satellite based on alpine-linux

# Status

[![Build Status](https://travis-ci.org/bodsch/docker-icinga2.svg?branch=dev)](https://travis-ci.org/bodsch/docker-icinga2)

# Build

Use included `Makefile`


# Docker Hub

You can find the Container also at  [DockerHub](https://hub.docker.com/r/bodsch/docker-icinga2/)


# supported Environment Vars

for MySQL Support:

  - MYSQL_HOST  (default: '')
  - MYSQL_PORT  (default: ```3306```)
  - MYSQL_ROOT_USER  (default: ```root```)
  - MYSQL_ROOT_PASS  (default: '')
  - IDO_DATABASE_NAME  (default: ```icinga2core```)
  - IDO_PASSWORD (default: generated with ```$(pwgen -s 15 1)```)

for graphite Support:

  - CARBON_HOST  (default: '')
  - CARBON_PORT  (default: 2003)

for dashing Support:

  - DASHING_API_USER  (optional)
  - DASHING_API_PASS  (optional)


for icinga2 Cluser:

  - ICINGA_CLUSTER (default: ```false```)
  - ICINGA_MASTER  (default: '')
  - ICINGA_SATELLITES (default: '')

