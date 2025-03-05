FROM golang:1.21-bookworm AS tools

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o /out/authctl ./cmd/authctl

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
COPY --from=tools /out/authctl /usr/local/bin/authctl
COPY --from=busybox:1.36.1 /bin/busybox /bin/busybox

COPY --from=certs /opt/trust /usr/local/share/ca-certificates/internal

COPY deploy/authd.toml /etc/authd/authd.toml
RUN sed -i "s/^# audit.*/audit = true/" /etc/authd/authd.toml

EXPOSE 4000
ENTRYPOINT ["/usr/local/bin/authd"]
