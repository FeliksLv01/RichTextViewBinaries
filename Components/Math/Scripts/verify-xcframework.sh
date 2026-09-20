#!/bin/bash

set -euo pipefail

FRAMEWORK="${1:-$(cd "$(dirname "$0")/.." && pwd)/Artifacts/iosMath.xcframework}"
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

for slice in ios-arm64 ios-arm64_x86_64-simulator; do
  binary="$FRAMEWORK/$slice/iosMath.framework/iosMath"
  info="$FRAMEWORK/$slice/iosMath.framework/Info.plist"
  [[ -f "$binary" ]] || { echo "Missing $binary" >&2; exit 1; }
  [[ -f "$info" ]] || { echo "Missing $info" >&2; exit 1; }
  file "$binary" | grep -q 'current ar archive' || { echo "Expected static archive in $slice" >&2; exit 1; }
  archive="$binary"
  if lipo -info "$binary" | grep -q '^Architectures in the fat file'; then
    archive="$TEMP_DIR/$slice.a"
    lipo "$binary" -thin arm64 -output "$archive"
  fi
  ar -t "$archive" | grep -q '^MTEmbeddedFonts.o$' || { echo "Missing embedded math fonts in $slice" >&2; exit 1; }
done
