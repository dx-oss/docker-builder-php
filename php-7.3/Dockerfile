ARG DOCKER_IMAGE=bitnami/php-fpm:7.3.11-debian-9-r20-prod
FROM composer:1.9 as composer
FROM csakshaug/of-watchdog-wrapper as  wrapper
FROM openfaas/of-watchdog:0.7.2 as watchdog
FROM dxcn/ssht:0.0.2 as ssht
FROM dxdx/env-tester:v0.0.1 as env-tester
FROM ${DOCKER_IMAGE} as base
ARG TRACKMAN_VERSION=1.0.1
ARG SECRETHUB_VERSION=v0.31.0
ARG SECRETHUB_VERSION_PKG=secrethub-${SECRETHUB_VERSION}-linux-amd64.deb
USER root
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
COPY --from=wrapper /usr/bin/of-watchdog-wrapper /usr/bin/of-watchdog-wrapper
COPY --from=ssht /usr/bin/ssht /usr/bin/ssht
COPY --from=env-tester /usr/bin/env-tester /usr/bin/env-tester
COPY init_ssh.sh /usr/local/bin
RUN apt-get update \
    && apt-get install -y unzip ssh git ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/.ssh \
    && rm /etc/ssh/ssh_host_* \
    && curl -sSL https://github.com/cloud66-oss/trackman/releases/download/${TRACKMAN_VERSION}/linux_amd64_${TRACKMAN_VERSION} -o /usr/local/bin/trackman \
    && chmod +x /usr/local/bin/trackman \    
    && curl -sSL https://github.com/secrethub/secrethub-cli/releases/download/${SECRETHUB_VERSION}/${SECRETHUB_VERSION_PKG} -o /tmp/${SECRETHUB_VERSION_PKG} \
    && dpkg -i /tmp/${SECRETHUB_VERSION_PKG} && rm /tmp/${SECRETHUB_VERSION_PKG} \
    && secrethub --version \
    && curl -Lfs -o /sbin/tini https://github.com/krallin/tini/releases/download/v0.18.0/tini \
    && chmod +x /sbin/tini \
    && chmod +x /usr/local/bin/init_ssh.sh
