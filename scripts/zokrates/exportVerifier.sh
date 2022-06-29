#!/usr/bin/env bash
set -e

if [ "$#" -lt 1 ]; then
  echo "Wrong number of arguments, usage: buildZokrates.sh [CIRCUIT_NAME]"
  exit 1
fi

BASE=$(cd "$(dirname "$0")";pwd)
ROOT="${BASE}/../.."
BUILD="${ROOT}/build/zokrates"
SRC="${ROOT}/circuits/zokrates"
DIST="${ROOT}/dist/zokrates/dev"
CIRCUIT="$1"

rm -rf "${BUILD}/${CIRCUIT}.*"
rm -rf "${DIST}/${CIRCUIT}.*"
mkdir -p "${BUILD}"
mkdir -p "${DIST}"

if [[ -z "${NO_EXPORT}" ]]; then
  mkdir -p "${BUILD}/contracts/verifiers"
  cp ${DIST}/${CIRCUIT}.vkey.gz ${BUILD}
  gunzip ${BUILD}/${CIRCUIT}.vkey.gz
  zokrates export-verifier -i "${BUILD}/${CIRCUIT}.vkey" -o "${BUILD}/contracts/verifiers/${CIRCUIT}Verifier.sol"
  sed -i '' "s/Verifier/${CIRCUIT}Verifier/g" "${BUILD}/contracts/verifiers/${CIRCUIT}Verifier.sol"
  sed -i '' "s/Pairing/${CIRCUIT}Pairing/g" "${BUILD}/contracts/verifiers/${CIRCUIT}Verifier.sol"
  rm ${BUILD}/${CIRCUIT}.vkey
fi
