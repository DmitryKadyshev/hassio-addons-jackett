ARG BUILD_FROM
# hadolint ignore=DL3006
FROM $BUILD_FROM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG BUILD_ARCH
ARG JACKETT_RELEASE

ENV XDG_CONFIG_HOME="/config"

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
              libicu66 \
              libssl1.1 \
              wget \
              curl \
    && useradd --system --no-create-home --home-dir /config jackett \
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

COPY rootfs /
