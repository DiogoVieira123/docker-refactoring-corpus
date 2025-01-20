FROM debian:12-slim

RUN apt-get update && apt-get install -y --no-install-recommends python3 python3-pip && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/worker

COPY . /srv/worker
COPY requirements.txt /srv/worker/requirements.txt

RUN pip3 install --no-cache-dir --break-system-packages -r /srv/worker/requirements.txt

COPY deploy/worker.toml /tmp/worker.toml
RUN mv /tmp/worker.toml /etc/worker.toml

CMD ["python3", "-m", "worker.tasks"]
