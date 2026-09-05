ARG BUILD_FROM
FROM $BUILD_FROM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG BUILD_ARCH
ARG JACKETT_RELEASE

ENV XDG_CONFIG_HOME="/config"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
              libicu66 \
              libssl1.1 \
              wget \
              curl \
    && mkdir -p /opt/Jackett \
    && if [ -z "${JACKETT_RELEASE}" ]; then \
              JACKETT_RELEASE=$(curl -sX GET "https://api.github.com/repos/Jackett/Jackett/releases/latest" | jq -r .tag_name); \
        fi \
    && ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "aarch64" ]; then ARCH="ARM64"; fi \
    && if [ "${BUILD_ARCH}" = "amd64" ]; then ARCH="AMDx64"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then ARCH="ARM32"; fi \
    && curl -o /tmp/jackett.tar.gz -L \
        "https://github.com/Jackett/Jackett/releases/download/${JACKETT_RELEASE}/Jackett.Binaries.Linux${ARCH}.tar.gz" \
    && tar xf /tmp/jackett.tar.gz -C /opt/Jackett --strip-components=1 \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /etc/nginx

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${JACKETT_RELEASE} \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF}
