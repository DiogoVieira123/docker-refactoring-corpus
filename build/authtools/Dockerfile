FROM golang:1.21-bookworm AS build

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o /out/authctl ./cmd/authctl
RUN CGO_ENABLED=0 go build -o /out/policyctl ./cmd/policyctl

FROM busybox:1.36.1

COPY --from=build /out/ /out/

CMD ["/out/authctl"]
