' Khmer Luna Date - Standalone Launcher
' Double-click to open the app in a dedicated window

Dim objShell, url
Set objShell = CreateObject("WScript.Shell")
url = "https://khmer-luna-office-addin.onrender.com/taskpane/taskpane.html"

' Open in default browser
objShell.Run url, 1, False
