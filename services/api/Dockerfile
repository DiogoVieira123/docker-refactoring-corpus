FROM node:20.11.1-bookworm-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*

ADD package.json /app/package.json
ADD package-lock.json /app/package-lock.json

RUN npm ci --omit=dev

ADD src /app/src

EXPOSE 3000
CMD ["node", "src/server.js"]
