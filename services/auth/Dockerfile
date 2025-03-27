FROM alpine:latest AS sidecar

RUN mkdir -p /opt/probe \
 && printf '#!/bin/sh\nexec wget -q -O /dev/null http://127.0.0.1:4000/healthz\n' > /opt/probe/probe \
 && chmod 0755 /opt/probe/probe

FROM debian:12-slim AS manifest

COPY deploy/manifest.json /opt/manifest/manifest.json

FROM golang:1.21-bookworm AS compile

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o /out/authd ./cmd/authd

FROM platform/ca_bundle:2024.1 AS certs

FROM debian:12-slim

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=compile /out/authd /usr/local/bin/authd
COPY --from=compile /src/migrations /opt/authd/migrations
COPY --from=ghcr.local/platform/authtools:1.4.0 /out/policyctl /usr/local/bin/policyctl
COPY --from=ghcr.local/platform/authtools:1.4.0 /out/authctl /usr/local/bin/authctl
COPY --from=busybox:1.36.1 /bin/busybox /bin/busybox

COPY --from=certs /opt/trust /usr/local/share/ca-certificates/internal

COPY --from=sidecar /opt/probe /usr/local/bin/probe
COPY --from=manifest /opt/manifest /opt/manifest

COPY deploy/authd.toml /etc/authd/authd.toml
RUN sed -i "s/^# audit.*/audit = true/" /etc/authd/authd.toml

EXPOSE 4000
ENTRYPOINT ["/usr/local/bin/authd"]
