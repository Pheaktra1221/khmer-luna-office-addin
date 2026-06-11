# Khmer Luna Date - Mac Office Integration

Since Mac Office doesn't support COM add-ins like Windows, this provides the closest alternative: a Quick Action that appears in Office's toolbar.

## Installation (Mac)

### Option 1: Automator Quick Action (Recommended)

1. Open **Automator** (Applications → Automator)
2. Click **New Document** → Select **Quick Action**
3. Set "Workflow receives" to **no input** in **any application**
4. In the action library on the left, search for **"Run AppleScript"**
5. Drag it to the workflow area
6. Replace the default code with:

```applescript
on run {input, parameters}
	set calendarURL to "https://khmer-luna-office-addin.onrender.com/taskpane/taskpane.html"
	
	tell application "Safari"
		activate
		tell window 1
			set current tab to (make new tab with properties {URL:calendarURL})
		end tell
	end tell
	
	return input
end run
```

7. Save as **"Khmer Luna Date"** (File → Save)
8. Open Word/Excel
9. Right-click the toolbar → **Customize Toolbar**
10. Drag the **Quick Actions** button to the toolbar
11. Click it, then select **Khmer Luna Date**

### Option 2: Keyboard Shortcut

1. After creating the Quick Action above
2. Go to **System Preferences → Keyboard → Shortcuts → Services**
3. Find **Khmer Luna Date** in the list
4. Click **Add Shortcut** and assign (e.g., ⌘⇧K)
5. Now press that shortcut in Office to open the calendar

### Option 3: Dock Icon

1. Open **Script Editor** (Applications → Utilities → Script Editor)
2. Paste the AppleScript from above
3. Save as **Application** (File → Export → File Format: Application)
4. Save to Applications folder
5. Drag to Dock for quick access

---

## Why Mac is Different

Mac Office doesn't support:
- COM add-ins (Windows-only)
- Custom ribbon tabs like Windows VSTO
- Web Add-in sideloading in Office 2021 (same as your Windows issue)

The Quick Action method above is the **closest Mac equivalent** to having a button in the Office toolbar.

---

## Alternative: Just Bookmark It

The simplest solution:
1. Open Safari
2. Go to https://khmer-luna-office-addin.onrender.com/taskpane/taskpane.html
3. Bookmarks → Add Bookmark → Save to Favorites Bar
4. Click it anytime you need to convert a date
