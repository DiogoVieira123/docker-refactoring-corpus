FROM node:20.11.1-bookworm-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*

COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

RUN npm ci --omit=dev

COPY src /app/src

EXPOSE 3000
CMD ["node", "src/server.js"]
