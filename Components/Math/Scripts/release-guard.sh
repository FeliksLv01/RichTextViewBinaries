#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="$(tr -d '[:space:]' < "$ROOT_DIR/VERSION")"
TAG="iosMath-$VERSION"

[[ "${GITHUB_REF:-}" == "refs/heads/main" ]] || { echo "Releases are only allowed from main" >&2; exit 1; }
[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Invalid version: $VERSION" >&2; exit 1; }
git -C "$ROOT_DIR" rev-parse "$TAG" >/dev/null 2>&1 && { echo "Tag already exists: $TAG" >&2; exit 1; }
echo "$TAG"
