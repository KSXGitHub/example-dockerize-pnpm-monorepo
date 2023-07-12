#!/bin/bash
set -o errexit -o pipefail -o nounset
cd "$(dirname "$0")"
podman build . --target foo --tag foo:latest
podman build . --target bar --tag bar:latest
