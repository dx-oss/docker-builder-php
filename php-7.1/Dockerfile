ARG DOCKER_IMAGE=bitnami/php-fpm:7.1.33-debian-9-r20-prod
FROM composer:1.9 as composer
FROM csakshaug/of-watchdog-wrapper as  wrapper
FROM openfaas/of-watchdog:0.7.2 as watchdog
FROM dxcn/ssht:0.0.2 as ssht
FROM ${DOCKER_IMAGE} as base
ARG TRACKMAN_VERSION=1.0.1
USER root
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
COPY --from=wrapper /usr/bin/of-watchdog-wrapper /usr/bin/of-watchdog-wrapper
COPY --from=ssht /usr/bin/ssht /usr/bin/ssht
RUN apt-get update \
    && apt-get install -y unzip ssh git ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/.ssh \
    && rm /etc/ssh/ssh_host_* \
    && curl -sSL https://github.com/cloud66-oss/trackman/releases/download/${TRACKMAN_VERSION}/linux_amd64_${TRACKMAN_VERSION} -o /usr/local/bin/trackman \
    && chmod +x /usr/local/bin/trackman \    
    && curl -Lfs -o /sbin/tini https://github.com/krallin/tini/releases/download/v0.18.0/tini \
    && chmod +x /sbin/tini
