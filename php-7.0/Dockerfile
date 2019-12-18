ARG DOCKER_IMAGE=bitnami/php-fpm:7.0.33-debian-9-r20-prod
FROM composer:1.9 as composer
FROM csakshaug/of-watchdog-wrapper as  wrapper
FROM openfaas/of-watchdog:0.7.2 as watchdog
FROM dxcn/ssht:0.0.2 as ssht
FROM ${DOCKER_IMAGE} as base
USER root
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
COPY --from=wrapper /usr/bin/of-watchdog-wrapper /usr/bin/of-watchdog-wrapper
COPY --from=ssht /usr/bin/ssht /usr/bin/ssht
RUN apt-get update \
    && apt-get install -y unzip ssh git ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && rm rm /etc/ssh/ssh_host_* \
    && mkdir -p /root/.ssh \
    && curl -Lfs -o /sbin/tini https://github.com/krallin/tini/releases/download/v0.18.0/tini \
    && chmod +x /sbin/tini
