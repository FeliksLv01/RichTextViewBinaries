#!/bin/bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FRAMEWORK_DIR="$ROOT_DIR/Artifacts/iosMath.xcframework/ios-arm64_x86_64-simulator"
TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT
DEVICE="${SIMULATOR_UDID:-$(xcrun simctl list devices available -j | ruby -rjson -e 'd=JSON.parse(STDIN.read)["devices"].values.flatten.select { |v| v["name"].include?("iPhone") }; puts((d.find { |v| v["state"] == "Booted" } || d.first).fetch("udid"))')}"
xcrun simctl boot "$DEVICE" 2>/dev/null || true
xcrun simctl bootstatus "$DEVICE" -b
xcrun --sdk iphonesimulator clang -arch "$(uname -m)" -mios-simulator-version-min=15.0 -fobjc-arc -fmodules \
  -F "$FRAMEWORK_DIR" -framework Foundation -framework UIKit -framework CoreText -framework iosMath \
  "$ROOT_DIR/Tests/BoxedCheck.m" -o "$TEST_DIR/boxed-check"
xcrun simctl spawn "$DEVICE" "$TEST_DIR/boxed-check"
