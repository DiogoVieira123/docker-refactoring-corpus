# Image for the queue worker.
#
# Instructions are grouped from the least volatile to the most volatile so
# that a task change only invalidates the last few layers.

FROM python:3.11-slim-bookworm

WORKDIR /srv/worker

# python dependencies, rebuilt when the lock file moves
COPY requirements.txt /srv/worker/requirements.txt

RUN pip3 install --no-cache-dir --break-system-packages -r /srv/worker/requirements.txt

COPY deploy/worker.toml /etc/worker.toml

# task code, rebuilt on every commit
COPY . /srv/worker

CMD ["python3", "-m", "worker.tasks"]
