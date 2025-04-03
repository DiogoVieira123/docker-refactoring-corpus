#!/bin/sh
set -eu

mkdir -p /var/lib/worker/reports
cp /opt/statement_assets/letterhead.txt /var/lib/worker/reports/letterhead.txt

chmod -R a+r /opt/statement_assets
chown -R 10002:10002 /var/lib/worker/reports

ln -sf /opt/statement_assets /var/lib/worker/reports/assets
