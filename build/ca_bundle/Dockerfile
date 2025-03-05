FROM busybox:1.36.1

WORKDIR /trust

COPY certs/ ./

RUN mkdir -p /opt/trust && cat ./*.crt > /opt/trust/internal_ca_bundle.crt
