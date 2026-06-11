#!/bin/bash
# Khmer Luna Date - Mac Installer
# Run: bash install-mac.sh

MANIFEST_URL="https://khmer-luna-office-addin.onrender.com/manifest.xml"
ADDIN_DIR="$HOME/Library/Containers/com.microsoft.Word/Data/Documents/wef"

echo "🌙 Installing Khmer Luna Date for Office on Mac..."
echo ""

# Create wef directory if it doesn't exist
mkdir -p "$ADDIN_DIR"

# Download manifest
echo "Downloading manifest..."
curl -sL "$MANIFEST_URL" -o "$ADDIN_DIR/manifest.xml"

if [ $? -eq 0 ]; then
    echo "✅ Manifest downloaded to: $ADDIN_DIR/manifest.xml"
else
    echo "❌ Failed to download manifest"
    exit 1
fi

# Also add for Excel and PowerPoint
EXCEL_DIR="$HOME/Library/Containers/com.microsoft.Excel/Data/Documents/wef"
PPT_DIR="$HOME/Library/Containers/com.microsoft.Powerpoint/Data/Documents/wef"

mkdir -p "$EXCEL_DIR"
mkdir -p "$PPT_DIR"

cp "$ADDIN_DIR/manifest.xml" "$EXCEL_DIR/manifest.xml" 2>/dev/null
cp "$ADDIN_DIR/manifest.xml" "$PPT_DIR/manifest.xml" 2>/dev/null

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Close all Office apps (Word, Excel, PowerPoint)"
echo "2. Reopen Word/Excel/PowerPoint"
echo "3. Go to Insert → Add-ins → My Add-ins"
echo "4. The add-in should appear under 'Developer Add-ins'"
echo ""
echo "If you don't see it, look for the 'Khmer Luna' button in the Home ribbon."
