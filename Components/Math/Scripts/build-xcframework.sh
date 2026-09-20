#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="${BUILD_DIR:-$ROOT_DIR/.build/xcframework}"
OUTPUT_DIR="${OUTPUT_DIR:-$ROOT_DIR/Artifacts}"

if [[ ! -f "$ROOT_DIR/Vendor/iosMath/iosMath/render/MTMathUILabel.m" ]]; then
  echo "Missing iosMath submodule. Run: git submodule update --init" >&2
  exit 1
fi

rm -rf "$BUILD_DIR" "$OUTPUT_DIR" "$ROOT_DIR/iosMath.xcodeproj" "$ROOT_DIR/.build/source"
mkdir -p "$BUILD_DIR" "$OUTPUT_DIR" "$ROOT_DIR/.build/source"
git clone --quiet --depth=1 "file://$ROOT_DIR/Vendor/iosMath" "$ROOT_DIR/.build/source/iosMath"
git -C "$ROOT_DIR/.build/source/iosMath" apply "$ROOT_DIR/Patches/iosMath-static-fonts.patch"
"$ROOT_DIR/Scripts/embed-fonts.rb" \
  "$ROOT_DIR/.build/source/iosMath" \
  "$ROOT_DIR/Vendor/iosMath/iosMath/fonts" \
  "$ROOT_DIR/.build/embedded"
sed -i '' 's|"lib/MTMathList.h"|"MTMathList.h"|' \
  "$ROOT_DIR/.build/source/iosMath/iosMath/render/MTFontManager.h" \
  "$ROOT_DIR/.build/source/iosMath/iosMath/render/MTMathUILabel.h" \
  "$ROOT_DIR/.build/source/iosMath/iosMath/render/MTMathListDisplay.h"

(cd "$ROOT_DIR" && xcodegen generate --spec project.yml)

archive() {
  local destination="$1"
  local archive_path="$2"
  local derived_data="$3"

  set -o pipefail
  xcodebuild archive \
    -project "$ROOT_DIR/iosMath.xcodeproj" \
    -scheme iosMath \
    -destination "$destination" \
    -archivePath "$archive_path" \
    -derivedDataPath "$derived_data" \
    -configuration Release \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    CODE_SIGNING_ALLOWED=NO 2>&1 | xcbeautify
}

archive "generic/platform=iOS" "$BUILD_DIR/iosMath-iOS.xcarchive" "$BUILD_DIR/DerivedData-iOS"
archive "generic/platform=iOS Simulator" "$BUILD_DIR/iosMath-iOS-Simulator.xcarchive" "$BUILD_DIR/DerivedData-iOS-Simulator"

xcodebuild -create-xcframework \
  -framework "$BUILD_DIR/iosMath-iOS.xcarchive/Products/Library/Frameworks/iosMath.framework" \
  -framework "$BUILD_DIR/iosMath-iOS-Simulator.xcarchive/Products/Library/Frameworks/iosMath.framework" \
  -output "$OUTPUT_DIR/iosMath.xcframework"

"$ROOT_DIR/Scripts/verify-xcframework.sh" "$OUTPUT_DIR/iosMath.xcframework"
