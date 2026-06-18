#!/usr/bin/env bash
# Copy addon_files/ into LineageOS source root (repo diff does not include new files).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC_ROOT="${1:-$(cd "$ROOT/../.." && pwd)}"

if [ ! -d "$SRC_ROOT/bionic" ] || [ ! -d "$SRC_ROOT/frameworks/base" ]; then
  echo "Usage: $0 [lineage_source_root]" >&2
  echo "Could not find LineageOS tree at: $SRC_ROOT" >&2
  exit 1
fi

if [ ! -d "$ROOT/addon_files" ]; then
  echo "No addon_files/ directory." >&2
  exit 1
fi

echo "Installing addon files into $SRC_ROOT"
(cd "$ROOT/addon_files" && find . -type f) | while read -r rel; do
  rel="${rel#./}"
  dest="$SRC_ROOT/$rel"
  mkdir -p "$(dirname "$dest")"
  cp -a "$ROOT/addon_files/$rel" "$dest"
  echo "  + $rel"
done

if [ -d "$ROOT/vendor_artist/config" ]; then
  mkdir -p "$SRC_ROOT/vendor/artist"
  cp -a "$ROOT/vendor_artist/config "$SRC_ROOT/vendor/artist/"
  cp -a "$ROOT/vendor_artist/overlay "$SRC_ROOT/vendor/artist/"
  echo "  + vendor/artist/{config,overlay}"
fi

echo "Done."
