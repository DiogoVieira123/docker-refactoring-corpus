FROM alpine:3.19 AS probe

RUN mkdir -p /opt/probe \
 && printf '#!/bin/sh\nexec wget -q -O /dev/null http://127.0.0.1:4000/healthz\n' > /opt/probe/probe \
 && chmod 0755 /opt/probe/probe

FROM golang:1.21-bookworm AS compile

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o /out/authd ./cmd/authd

FROM platform/ca_bundle:2024.1 AS trust

FROM debian:12-slim AS policy

COPY policies/ /tmp/policies/
COPY deploy/authd.toml /etc/authd/authd.toml

RUN set -eux \
 && apt-get update \
 && apt-get install -y --no-install-recommends xz-utils \
 && mkdir -p /opt/authd/policies \
 && cp -r /tmp/policies/. /opt/authd/policies/ \
 && chmod -R a+r /opt/authd/policies \
 && sed -i "s/^# audit.*/audit = true/" /etc/authd/authd.toml \
 && rm -rf /tmp/policies /var/lib/apt/lists/*

FROM gcr.io/distroless/base-debian12:nonroot

COPY --from=compile /out/authd /usr/local/bin/authd
COPY --from=compile /src/migrations /opt/authd/migrations
COPY --from=ghcr.local/platform/authtools:1.4.0 /out/policyctl /usr/local/bin/policyctl
COPY --from=ghcr.local/platform/authtools:1.4.0 /out/authctl /usr/local/bin/authctl
COPY --from=busybox:1.36.1 /bin/busybox /bin/busybox

COPY --from=trust /opt/trust /usr/local/share/ca-certificates/internal
COPY --from=policy /opt/authd/policies /opt/authd/policies

COPY --from=probe /opt/probe /usr/local/bin/probe
COPY deploy/manifest.json /opt/manifest/manifest.json

COPY --from=policy /etc/authd/authd.toml /etc/authd/authd.toml

EXPOSE 4000
ENTRYPOINT ["/usr/local/bin/authd"]
