#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPO_ROOT="$(cd "$ROOT_DIR/../.." && pwd)"
RELEASE_DIR="${RELEASE_DIR:-$ROOT_DIR/.build/release}"

"$ROOT_DIR/Scripts/verify-xcframework.sh" "$ROOT_DIR/Artifacts/iosMath.xcframework"
"$REPO_ROOT/Scripts/package-xcframework.sh" \
  "$ROOT_DIR/Artifacts/iosMath.xcframework" \
  "$RELEASE_DIR/iosMath.xcframework.zip" \
  "$ROOT_DIR/LICENSE"
