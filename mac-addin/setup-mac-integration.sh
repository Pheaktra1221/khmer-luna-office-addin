#!/bin/bash
# Khmer Luna Date - Mac Office Integration Setup

echo "🌙 Setting up Khmer Luna Date for Mac Office"
echo ""

# 1. Create the AppleScript app
SCRIPT_DIR="$HOME/Library/Scripts/Applications/Microsoft Word"
mkdir -p "$SCRIPT_DIR"

cat > "$SCRIPT_DIR/Khmer Luna Date.scpt" << 'EOF'
on run
	set calendarURL to "https://khmer-luna-office-addin.onrender.com/taskpane/taskpane.html"
	
	tell application "Safari"
		activate
		make new document with properties {URL:calendarURL}
	end tell
end run
EOF

echo "✅ Script installed to: $SCRIPT_DIR"

# 2. Instructions
echo ""
echo "📋 Setup Instructions:"
echo ""
echo "METHOD 1: Script Menu (Recommended)"
echo "-----------------------------------"
echo "1. Open Script Editor (Applications → Utilities → Script Editor)"
echo "2. Go to Preferences → General"
echo "3. Check 'Show Script menu in menu bar'"
echo "4. A scroll icon will appear in your menu bar"
echo "5. In Word, click the scroll icon → Microsoft Word → Khmer Luna Date"
echo ""
echo "METHOD 2: Keyboard Shortcut"
echo "---------------------------"
echo "1. Go to System Preferences → Keyboard → Shortcuts → App Shortcuts"
echo "2. Click '+' to add new"
echo "3. Application: Microsoft Word"
echo "4. Menu Title: Khmer Luna Date"
echo "5. Keyboard Shortcut: ⌘⇧K (or your choice)"
echo ""
echo "METHOD 3: Automator Service"
echo "---------------------------"
echo "1. Open Automator → New → Quick Action"
echo "2. Set 'Workflow receives: no input in any application'"
echo "3. Add 'Run AppleScript' action"
echo "4. Paste the script from: $SCRIPT_DIR/Khmer Luna Date.scpt"
echo "5. Save as 'Khmer Luna Date'"
echo "6. In Word toolbar, right-click → Customize Toolbar → add Quick Actions"
echo ""
echo "✅ Setup complete!"
