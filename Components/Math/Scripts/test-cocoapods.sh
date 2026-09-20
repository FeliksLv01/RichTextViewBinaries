#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
STAGING_DIR="$(mktemp -d)"
trap 'rm -rf "$STAGING_DIR"' EXIT

ditto -x -k "$ROOT_DIR/.build/release/iosMath.xcframework.zip" "$STAGING_DIR"
cp "$ROOT_DIR/RichTextViewMathBinary.podspec" "$ROOT_DIR/LICENSE" "$STAGING_DIR"

ruby -e 'require "cocoapods"; Pod::Command.plugin_prefixes = []; Pod::Command.run(ARGV)' -- \
  lib lint "$STAGING_DIR/RichTextViewMathBinary.podspec" \
  --allow-warnings \
  --platforms=ios \
  --verbose
