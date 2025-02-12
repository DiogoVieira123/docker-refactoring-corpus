FROM golang:1.21-bookworm AS tools

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o /out/authctl ./cmd/authctl

FROM golang:1.21-bookworm AS builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o /out/authd ./cmd/authd

FROM builder AS vet

RUN go vet ./...

FROM debian:12-slim

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /out/authd /usr/local/bin/authd
COPY --from=builder /src/migrations /opt/authd/migrations
COPY --from=tools /out/authctl /usr/local/bin/authctl

EXPOSE 4000
ENTRYPOINT ["/usr/local/bin/authd"]
