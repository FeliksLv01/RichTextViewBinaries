#!/bin/bash

set -euo pipefail

FRAMEWORK="$1"
ZIP_PATH="$2"
shift 2

STAGING_DIR="$(mktemp -d)"
trap 'rm -rf "$STAGING_DIR"' EXIT

ditto "$FRAMEWORK" "$STAGING_DIR/$(basename "$FRAMEWORK")"
for extra in "$@"; do
  ditto "$extra" "$STAGING_DIR/$(basename "$extra")"
done

rm -f "$ZIP_PATH"
mkdir -p "$(dirname "$ZIP_PATH")"
ditto -c -k --sequesterRsrc "$STAGING_DIR" "$ZIP_PATH"
swift package compute-checksum "$ZIP_PATH"
