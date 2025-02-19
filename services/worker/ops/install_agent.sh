#!/bin/sh
set -eu

mkdir -p /opt/agent/bin
cp /srv/worker/ops/agent.sh /opt/agent/bin/agent
chmod 0755 /opt/agent/bin/agent
ln -sf /opt/agent/bin/agent /usr/local/bin/agent
mkdir -p /var/log/agent
