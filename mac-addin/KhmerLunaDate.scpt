-- Khmer Luna Date - Mac Office Add-in
-- This AppleScript opens the calendar in a Safari window for easy access

on run
	set calendarURL to "https://khmer-luna-office-addin.onrender.com/taskpane/taskpane.html"
	
	tell application "Safari"
		activate
		tell window 1
			set current tab to (make new tab with properties {URL:calendarURL})
		end tell
	end tell
end run
