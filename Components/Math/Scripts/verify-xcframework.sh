#!/bin/bash

set -euo pipefail

FRAMEWORK="${1:-$(cd "$(dirname "$0")/.." && pwd)/Artifacts/iosMath.xcframework}"

for slice in ios-arm64 ios-arm64_x86_64-simulator; do
  binary="$FRAMEWORK/$slice/iosMath.framework/iosMath"
  fonts="$FRAMEWORK/$slice/iosMath.framework/fonts"
  info="$FRAMEWORK/$slice/iosMath.framework/Info.plist"
  [[ -f "$binary" ]] || { echo "Missing $binary" >&2; exit 1; }
  [[ -f "$info" ]] || { echo "Missing $info" >&2; exit 1; }
  [[ -f "$fonts/latinmodern-math.otf" ]] || { echo "Missing bundled math fonts in $slice" >&2; exit 1; }
  file "$binary"
done
