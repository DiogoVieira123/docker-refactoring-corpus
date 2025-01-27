FROM golang:1.21-bookworm

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o /usr/local/bin/authd ./cmd/authd

EXPOSE 4000
ENTRYPOINT ["/usr/local/bin/authd"]
