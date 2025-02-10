FROM node:20.11.1-bookworm-slim

ENV APP_HOME=/app \
    NODE_ENV=production \
    PORT=3000

WORKDIR ${APP_HOME}

LABEL org.opencontainers.image.title="api" org.opencontainers.image.version="1.4.0" org.opencontainers.image.vendor="Platform" com.platform.owner="core team" com.platform.support="#core"

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        jq \
        tzdata \
 && mkdir -p /opt/support/bin \
 && ln -sf /usr/bin/jq /opt/support/bin/jq \
 && ln -snf /usr/share/zoneinfo/Etc/UTC /etc/localtime \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ADD https://raw.githubusercontent.com/nodejs/node/v20.12.0/LICENSE /opt/notices/node_license.txt

COPY package.json ${APP_HOME}/package.json
COPY package-lock.json ${APP_HOME}/package-lock.json

RUN npm ci --omit=dev

COPY src ${APP_HOME}/src

EXPOSE ${PORT}
CMD ["node", "src/server.js"]
