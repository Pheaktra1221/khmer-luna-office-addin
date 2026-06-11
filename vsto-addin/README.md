# Khmer Luna Date - COM Add-in (Excel-DNA)

This is a lightweight COM add-in that embeds the web calendar directly in Excel/Word ribbon.

## Build Instructions

### Prerequisites
- Visual Studio 2022 (Community edition is free)
- .NET Framework 4.7.2 or higher
- Excel-DNA library

### Steps

1. Install Visual Studio 2022 Community from https://visualstudio.microsoft.com/downloads/
2. During install, select ".NET desktop development" workload
3. Open solution in Visual Studio
4. Build → Build Solution
5. The .xll file will be generated in bin/Release

### Installation for Users

1. Copy KhmerLunaDate.xll to any folder (e.g., Documents)
2. Open Excel
3. Go to File → Options → Add-ins
4. Select "Excel Add-ins" from Manage dropdown → Go
5. Click Browse → Select KhmerLunaDate.xll
6. Check the box next to it → OK

The add-in button will appear in the ribbon.

---

**Alternative:** Since you need free distribution without code signing, I recommend sticking with the **web version** for now. Building and distributing COM add-ins properly requires:
- Code signing certificate ($200-400/year from DigiCert/Sectigo)
- Without it, Windows blocks installation with security warnings
- Complicates distribution significantly

The web version at https://khmer-luna-office-addin.onrender.com/taskpane/taskpane.html works identically and costs nothing to distribute.
