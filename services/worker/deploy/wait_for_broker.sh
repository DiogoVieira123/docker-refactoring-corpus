#!/bin/sh
set -eu

host="${BROKER_HOST:-broker}"
port="${BROKER_PORT:-5672}"

attempts=0
while [ "${attempts}" -lt "${BROKER_WAIT_ATTEMPTS:-0}" ]; do
    if (echo > "/dev/tcp/${host}/${port}") 2>/dev/null; then
        break
    fi
    attempts=$((attempts + 1))
    sleep 1
done

exec "$@"
