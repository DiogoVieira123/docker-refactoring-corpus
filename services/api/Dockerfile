FROM node:20-bookworm-slim

WORKDIR /app

RUN apt-get update
RUN apt-get install -y --no-install-recommends ca-certificates curl
RUN rm -rf /var/lib/apt/lists/*

ADD package.json /app/package.json
ADD package-lock.json /app/package-lock.json

RUN npm ci --omit=dev

ADD src /app/src

EXPOSE 3000
CMD ["node", "src/server.js"]
