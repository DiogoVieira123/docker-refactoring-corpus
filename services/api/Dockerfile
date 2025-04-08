# syntax=docker/dockerfile:1.7
ARG NODE_TAG=20.12.2-bookworm-slim

FROM node:${NODE_TAG}

ENV APP_HOME=/srv/api \
    NODE_ENV=production \
    PORT=8080

ENV API_UPLOAD_DIR /var/lib/api/uploads

ENV \
    API_LOG_FORMAT=json \
    API_REQUEST_TIMEOUT=30

WORKDIR ${APP_HOME}

LABEL org.opencontainers.image.title="api" \
      org.opencontainers.image.version="1.5.0" \
      org.opencontainers.image.vendor="Platform" \
      com.platform.owner="core team" \
      com.platform.support="#core"

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*

RUN <<SUPPORT_UTILITIES
set -eux
apt-get update
apt-get install -y --no-install-recommends jq tzdata
mkdir -p /opt/support/bin
ln -sf /usr/bin/jq /opt/support/bin/jq
ln -snf /usr/share/zoneinfo/Etc/UTC /etc/localtime
apt-get clean
rm -rf /var/lib/apt/lists/*
SUPPORT_UTILITIES

ADD https://raw.githubusercontent.com/nodejs/node/v20.12.0/LICENSE /opt/notices/node_license.txt

COPY package.json ${APP_HOME}/package.json
COPY package-lock.json ${APP_HOME}/package-lock.json

RUN npm ci --omit=dev

COPY --chown=10001:10001 \
     deploy/certs/ \
     /etc/api/certs/
COPY --chown=10001:10001 \
     deploy/trust/internal_ca.crt \
     /usr/local/share/ca-certificates/internal_ca.crt

COPY src ${APP_HOME}/src

# lay out the upload directories and record the runtime version
RUN ["/bin/sh", "-c", "mkdir -p /var/lib/api/uploads /var/lib/api/tmp && node --version > /var/lib/api/node_version"]

ARG RATE_LIMIT_MAX=120

ENV RATELIMIT_CONFIG=/etc/api/ratelimit.conf

RUN mkdir -p /etc/api \
 && printf 'window=60\nmax=%s\n' "${RATE_LIMIT_MAX}" > ${RATELIMIT_CONFIG} \
 && chmod 0644 ${RATELIMIT_CONFIG}

LABEL com.platform.ratelimit="${RATE_LIMIT_MAX}"

COPY docs/openapi.yaml ${APP_HOME}/openapi.yaml

RUN mkdir -p /opt/openapi \
 && cp ${APP_HOME}/openapi.yaml /opt/openapi/openapi.yaml \
 && chmod -R a+r /opt/openapi

EXPOSE ${PORT}
CMD ["node", "src/server.js"]
