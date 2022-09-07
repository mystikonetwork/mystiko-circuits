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

zokrates compile -i "${SRC}/${CIRCUIT}.zok" -o "${BUILD}/${CIRCUIT}.program" -s "${BUILD}/${CIRCUIT}.abi.json" -r "${BUILD}/${CIRCUIT}.r1cs"
zokrates setup -i "${BUILD}/${CIRCUIT}.program" -p "${BUILD}/${CIRCUIT}.pkey" -v "${BUILD}/${CIRCUIT}.vkey"

if [[ -z "${NO_EXPORT}" ]]; then
  mkdir -p "${BUILD}/contracts/verifiers"
  zokrates export-verifier -i "${BUILD}/${CIRCUIT}.vkey" -o "${BUILD}/contracts/verifiers/${CIRCUIT}Verifier.sol"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/contract Verifier/contract ${CIRCUIT}Verifier/g" "${BUILD}/contracts/verifiers/${CIRCUIT}Verifier.sol"
  else
    sed -i -e "s/contract Verifier/contract ${CIRCUIT}Verifier/g" "${BUILD}/contracts/verifiers/${CIRCUIT}Verifier.sol"
  fi

  cp "${BUILD}/${CIRCUIT}.program" "${DIST}/${CIRCUIT}.program"
  cp "${BUILD}/${CIRCUIT}.pkey" "${DIST}/${CIRCUIT}.pkey"
  cp "${BUILD}/${CIRCUIT}.vkey" "${DIST}/${CIRCUIT}.vkey"
  cp "${BUILD}/${CIRCUIT}.abi.json" "${DIST}/${CIRCUIT}.abi.json"

  gzip -9 "${DIST}/${CIRCUIT}.program"
  gzip -9 "${DIST}/${CIRCUIT}.pkey"
  gzip -9 "${DIST}/${CIRCUIT}.vkey"
fi
