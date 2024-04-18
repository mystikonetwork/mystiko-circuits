#!/usr/bin/env bash
set -e

BASE=$(cd "$(dirname "$0")";pwd)
ROOT="${BASE}/../.."
BUILDER="${ROOT}/scripts/zokrates/buildCircuit.sh"

bash "${BUILDER}" Transaction1x0
bash "${BUILDER}" Transaction1x1
bash "${BUILDER}" Transaction1x2
bash "${BUILDER}" Transaction2x0
bash "${BUILDER}" Transaction2x1
bash "${BUILDER}" Transaction2x2
bash "${BUILDER}" Rollup1
bash "${BUILDER}" Rollup2
bash "${BUILDER}" Rollup4
bash "${BUILDER}" Rollup8
bash "${BUILDER}" Rollup16
bash "${BUILDER}" Rollup32
bash "${BUILDER}" Rollup64
