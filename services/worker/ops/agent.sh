#!/bin/sh
set -eu

echo "metrics agent reporting queue depth from ${WORKER_SPOOL:-/var/lib/worker/spool}"
