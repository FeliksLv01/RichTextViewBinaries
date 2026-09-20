#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
COMPONENT="$1"
COMMAND="${2:-ci}"

case "$COMPONENT" in
  markdown) DIR="$ROOT_DIR/Components/Markdown" ;;
  tree-sitter) DIR="$ROOT_DIR/Components/TreeSitter" ;;
  math) DIR="$ROOT_DIR/Components/Math" ;;
  *) echo "Unknown component: $COMPONENT" >&2; exit 1 ;;
esac

case "$COMMAND" in
  build)
    if [[ "$COMPONENT" == "tree-sitter" ]]; then
      "$DIR/Scripts/build-xcframeworks.sh"
    else
      "$DIR/Scripts/build-xcframework.sh"
    fi
    ;;
  ci)
    if [[ "$COMPONENT" == "markdown" ]]; then
      "$DIR/Scripts/test-patch.sh"
      "$DIR/Scripts/test-source.sh"
      "$DIR/Scripts/test-release-scripts.sh"
      "$DIR/Scripts/build-xcframework.sh"
      "$DIR/Scripts/test-swiftpm.sh"
      "$DIR/Scripts/test-cocoapods.sh"
    elif [[ "$COMPONENT" == "tree-sitter" ]]; then
      "$DIR/Scripts/build-xcframeworks.sh"
      "$DIR/Scripts/test-swiftpm.sh"
      "$DIR/Scripts/test-cocoapods.sh"
    else
      "$DIR/Scripts/build-xcframework.sh"
      "$DIR/Scripts/package-release.sh"
      "$DIR/Scripts/test-cocoapods.sh"
    fi
    ;;
  package)
    "$DIR/Scripts/package-release.sh"
    ;;
  *) echo "Unknown command: $COMMAND" >&2; exit 1 ;;
esac
