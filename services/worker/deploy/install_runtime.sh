#!/bin/sh
set -eu

groupadd --system --gid 10002 worker
useradd --system --uid 10002 --gid worker --home /srv/worker worker

mkdir -p /var/lib/worker/spool /var/log/worker
chown -R worker:worker /var/lib/worker /var/log/worker /srv/worker

ln -snf /usr/share/zoneinfo/Etc/UTC /etc/localtime
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
printf 'umask 027\n' >> /etc/profile
