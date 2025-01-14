# Dockerfile Refactoring Corpus

Ground truth corpus for a Master thesis on the detection of dockerfile
refactorings. The history is strictly linear and every commit evolves one of
the three service images below.

## Layout

    services/api/Dockerfile      node service and its build context
    services/worker/Dockerfile   python worker and its build context
    services/auth/Dockerfile     go service and its build context
    build/                       independent build contexts consumed by the services
    mapping.json                 the ground truth, one entry per commit pair

## Building

Every revision in the history is meant to build with the context that sits next
to it. The two contexts under build/ publish images that the auth service
consumes, so they are built first.

    make contexts
    make services

Or build a single image directly.

    docker build -t platform/api:dev services/api

## Ground truth

mapping.json couples the revision before a change with the revision that
carries it. Each entry names the artifact, the rules that apply, the kind of
test case and what a detector is expected to report or must not report.
