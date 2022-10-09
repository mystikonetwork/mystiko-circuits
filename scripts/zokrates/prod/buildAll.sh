#!/usr/bin/env bash
set -e

BASE=$(cd "$(dirname "$0")";pwd)
ROOT="${BASE}/../../.."
BUILDER="${ROOT}/scripts/zokrates/buildAll.sh"
export MODE="prod"

bash "${BUILDER}" "$@"