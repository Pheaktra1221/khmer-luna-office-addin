#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST="$PROJECT_DIR/manifest.xml"

echo "Khmer Luna Office Add-in — macOS sideload"
echo "Manifest: $MANIFEST"
echo

copy_manifest() {
  local app_name="$1"
  local dest="$HOME/Library/Containers/com.microsoft.${app_name}/Data/Documents/wef"

  mkdir -p "$dest"
  cp "$MANIFEST" "$dest/"
  echo "Copied manifest to: $dest"
}

copy_manifest "Excel"
copy_manifest "Word"
copy_manifest "Powerpoint"

echo
echo "Next steps:"
echo "1. Run: npm start"
echo "2. Open Excel, Word, or PowerPoint"
echo "3. Home > Add-ins > select Khmer Luna Date"
echo
echo "If the add-in does not appear, quit and reopen the Office app."
