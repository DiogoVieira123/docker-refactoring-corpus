# Image for the queue worker.
#
# Instructions are grouped from the least volatile to the most volatile so
# that a task change only invalidates the last few layers.

FROM python:3.11-slim-bookworm

WORKDIR /srv/worker

# python dependencies, rebuilt when the lock file moves
COPY requirements.txt /srv/worker/requirements.txt

RUN pip3 install --no-cache-dir --break-system-packages -r /srv/worker/requirements.txt

RUN groupadd --system --gid 10002 worker \
 && useradd --system --uid 10002 --gid worker --home /srv/worker worker \
 && mkdir -p /var/lib/worker/spool /var/log/worker \
 && chown -R worker:worker /var/lib/worker /var/log/worker /srv/worker \
 && ln -snf /usr/share/zoneinfo/Etc/UTC /etc/localtime \
 && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && printf 'umask 027\n' >> /etc/profile

COPY deploy/worker.toml /etc/worker.toml

# task code, rebuilt on every commit
COPY . /srv/worker

COPY --chmod=0755 deploy/wait_for_broker.sh /usr/local/bin/wait_for_broker.sh

ENTRYPOINT ["/usr/local/bin/wait_for_broker.sh"]
CMD ["python3", "-m", "worker.tasks"]
