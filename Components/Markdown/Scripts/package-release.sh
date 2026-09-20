#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="$(tr -d '[:space:]' < "$ROOT_DIR/VERSION")"
XCFRAMEWORK_PATH="$ROOT_DIR/Markdown.xcframework"
ZIP_PATH="$ROOT_DIR/Markdown.xcframework.zip"
"$ROOT_DIR/Scripts/verify-xcframework.sh" "$XCFRAMEWORK_PATH"
REPO_ROOT="$(cd "$ROOT_DIR/../.." && pwd)"
SWIFTPM_CHECKSUM="$("$REPO_ROOT/Scripts/package-xcframework.sh" \
  "$XCFRAMEWORK_PATH" "$ZIP_PATH" "$ROOT_DIR/LICENSE" "$ROOT_DIR/NOTICE")"
SHA256="$(shasum -a 256 "$ZIP_PATH" | awk '{print $1}')"

echo "version=$VERSION"
echo "swiftpm_checksum=$SWIFTPM_CHECKSUM"
echo "sha256=$SHA256"
