# Image for the queue worker.
#
# Instructions are grouped from the least volatile to the most volatile so
# that a task change only invalidates the last few layers.

ARG PY_TAG=3.11-slim-bookworm
ARG BUILD_REVISION

FROM alpine:3.19 AS schema

WORKDIR /schema

COPY schema/ ./

RUN mkdir -p /opt/schema \
 && tar -czf /opt/schema/schema.tar.gz *.sql \
 && cp *.sql /opt/schema/

FROM docker.io/library/python:${PY_TAG}

ARG PY_TAG
ARG BUILD_REVISION

LABEL com.platform.base_tag="${PY_TAG}" \
      org.opencontainers.image.revision="${BUILD_REVISION:-unknown}"

WORKDIR /srv/worker

COPY fixtures /srv/worker/fixtures

# python dependencies, rebuilt when the lock file moves
COPY requirements.txt /srv/worker/requirements.txt

RUN pip3 install --no-cache-dir --break-system-packages -r /srv/worker/requirements.txt

COPY --chmod=0755 deploy/install_runtime.sh /tmp/install_runtime.sh
RUN /tmp/install_runtime.sh && rm /tmp/install_runtime.sh

COPY --chmod=0755 dist/pgclient /usr/local/bin/pgclient

COPY --chmod=0755 dist/queue_probe /usr/local/bin/queue_probe

COPY --from=schema /opt/schema /opt/schema

COPY deploy/worker.toml /etc/worker.toml

# task code, rebuilt on every commit
COPY . /srv/worker

RUN sh /srv/worker/ops/install_agent.sh

COPY --chmod=0755 deploy/wait_for_broker.sh /usr/local/bin/wait_for_broker.sh

ENTRYPOINT ["/usr/local/bin/wait_for_broker.sh"]
CMD ["python3", "-m", "worker.tasks"]
