#!/usr/bin/env bash
#
# Rebuild every historical revision of every service image.
#
# Usage: scripts/verify_builds.sh [first_commit]
#
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
work="$(mktemp -d)"
trap 'rm -rf "${work}"' EXIT

failures=0
checked=0

for sha in $(git -C "${repo_root}" rev-list --reverse HEAD); do
    changed="$(git -C "${repo_root}" show --pretty=format: --name-only "${sha}")"

    for service in api worker auth; do
        artifact="services/${service}/Dockerfile"
        case "${changed}" in
            *"${artifact}"*) ;;
            *) continue ;;
        esac

        tree="${work}/${sha}"
        mkdir -p "${tree}"
        git -C "${repo_root}" archive "${sha}" | tar -x -C "${tree}"

        # the contexts under build/ publish the images the services consume
        if [ -d "${tree}/build/ca_bundle" ]; then
            docker build -q -t platform/ca_bundle:2024.1 "${tree}/build/ca_bundle" >/dev/null
        fi
        if [ -d "${tree}/build/authtools" ]; then
            docker build -q -t platform/authtools:1.4.0 "${tree}/build/authtools" >/dev/null
            docker tag platform/authtools:1.4.0 ghcr.local/platform/authtools:1.4.0
        fi

        checked=$((checked + 1))
        if docker build -q -t "corpus/${service}:${sha}" "${tree}/services/${service}" >/dev/null; then
            echo "ok    ${sha} ${artifact}"
        else
            echo "FAIL  ${sha} ${artifact}"
            failures=$((failures + 1))
        fi
    done
done

echo
echo "${checked} revisions built, ${failures} failed"
[ "${failures}" -eq 0 ]
