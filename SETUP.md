# Khmer Luna Date — Step-by-Step Setup (Mac + Windows + Render)

Office add-in for **Excel, Word, PowerPoint** — works on **Office 2021** and other **non-Microsoft 365** installs.

## 4 output formats

| Option | Example |
|--------|---------|
| **1** — ចន្ទគតិ | `ថ្ងៃចន្ទ ១២ រោច ខែបុស្ស ឆ្នាំម្សាញ់ សប្តស័ក ព.ស.២៥៧០` |
| **2** — ពាក្យដើម + សុរិយគតិ | `ផ្លូវមាស ថ្ងៃទី១២ ខែមករា ឆ្នាំ២០២៦` |
| **3** — ទាំងពីរ (2 lines) | Option 1 + Option 2 |
| **4** — សុរិយគតិ | `ថ្ងៃទី១២ ខែមករា ឆ្នាំ២០២៦` |

**ផ្លូវមាស** can be changed to any label in the add-in (saved automatically).

---

## Part A — Deploy to Render (one time)

### Step 1: Push code to GitHub

1. Create a new repo on GitHub, e.g. `khmer-luna-office-addin`
2. In PowerShell or Terminal:

```bash
cd C:\Users\Gintra\Documents\khmer-luna-office-addin
git add .
git commit -m "Khmer Luna Office add-in with Render deployment"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/khmer-luna-office-addin.git
git push -u origin main
```

### Step 2: Create Render web service

1. Go to [https://render.com](https://render.com) and sign in
2. Click **New +** → **Blueprint** (or **Web Service**)
3. Connect your GitHub repo `khmer-luna-office-addin`
4. Render reads `render.yaml` automatically:
   - **Build:** `npm install && npm run build`
   - **Start:** `npm run start:production`
5. Click **Deploy**
6. Wait until status is **Live**
7. Copy your URL, e.g. `https://khmer-luna-date.onrender.com`

> Free tier may sleep after inactivity. First open takes ~30 seconds.

### Step 3: Download manifest from Render

After deploy, open in browser:

```
https://YOUR-APP.onrender.com/manifest.xml
```

Save the file as `manifest.xml` on your computer (Desktop is fine).

The manifest URLs are already set to your Render URL during build.

---

## Part B — Install in Office (Mac)

Works on **Office 2021 / 2019 / 2016 for Mac** (Excel, Word, PowerPoint).

### Step 1: Copy manifest to Office folders

Open **Terminal** and run (replace `YOUR_USER` and path to your saved manifest):

```bash
MANIFEST="$HOME/Desktop/manifest.xml"

mkdir -p "$HOME/Library/Containers/com.microsoft.Excel/Data/Documents/wef"
mkdir -p "$HOME/Library/Containers/com.microsoft.Word/Data/Documents/wef"
mkdir -p "$HOME/Library/Containers/com.microsoft.Powerpoint/Data/Documents/wef"

cp "$MANIFEST" "$HOME/Library/Containers/com.microsoft.Excel/Data/Documents/wef/"
cp "$MANIFEST" "$HOME/Library/Containers/com.microsoft.Word/Data/Documents/wef/"
cp "$MANIFEST" "$HOME/Library/Containers/com.microsoft.Powerpoint/Data/Documents/wef/"

echo "Done — restart Excel, Word, or PowerPoint"
```

Or from the project folder (uses local `manifest.xml` after you set Render URL):

```bash
cd ~/Documents/khmer-luna-office-addin
BASE_URL=https://YOUR-APP.onrender.com npm run build
npm run sideload:mac
```

### Step 2: Open Office app

1. **Quit** Excel / Word / PowerPoint completely (Cmd+Q)
2. Open again
3. Open any file

### Step 3: Load the add-in

1. Go to **Home** tab
2. Click **Add-ins**
3. Select **Khmer Luna Date**
4. Task pane opens on the right

### Step 4: Use it

1. Pick a date (or click **ប្រើថ្ងៃនេះ**)
2. Change **ផ្លូវមាស** if needed
3. Choose **Option 1 / 2 / 3 / 4**
4. Click **បញ្ចូល (Insert)** — cursor must be in document/cell first

**Excel tip:** select a cell with a date → **អានពី cell ដែលជ្រើស** → converts automatically.

---

## Part C — Install in Office (Windows)

Works on **Office 2021 / 2019 / 2016** (Excel, Word, PowerPoint).

### Step 1: Install WebView2 (required for Office 2021)

Download and install: [Microsoft Edge WebView2](https://developer.microsoft.com/microsoft-edge/webview2/)

### Step 2: Copy manifest

**Option A — PowerShell (recommended)**

Save `manifest.xml` from Render to Desktop, then:

```powershell
$manifest = "$env:USERPROFILE\Desktop\manifest.xml"
$wef = "$env:LOCALAPPDATA\Microsoft\Office\16.0\Wef"
New-Item -ItemType Directory -Force -Path $wef | Out-Null
Copy-Item $manifest (Join-Path $wef "manifest.xml") -Force
Write-Host "Done — restart Office"
```

**Option B — from project**

```powershell
cd C:\Users\Gintra\Documents\khmer-luna-office-addin
$env:BASE_URL="https://YOUR-APP.onrender.com"
npm run build
npm run sideload:windows
```

### Step 3: Open Office

1. Close all Office apps
2. Open Excel, Word, or PowerPoint
3. **Home → Add-ins → Khmer Luna Date**

### Step 4: Use it

Same as Mac — pick format, insert into cell or document.

---

## Part D — Local testing (optional, no Render)

For development on your own computer only:

```bash
cd C:\Users\Gintra\Documents\khmer-luna-office-addin
npm install
npm start
```

Keep the terminal running. Sideload with `npm run sideload:windows` or `npm run sideload:mac`.

Uses `https://localhost:3000` — **not** for other computers; use Render for that.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Add-in not in list | Quit Office fully, reopen. Re-copy manifest. |
| Blank task pane | Check Render URL is Live. Open `https://YOUR-APP.onrender.com/health` — should show `{"ok":true}` |
| Render slow first load | Free tier wakes from sleep — wait 30–60 sec |
| Insert does nothing | Click target cell / place cursor first |
| Mac: add-in missing | Confirm manifest in all 3 `wef` folders, restart app |
| Windows: blank pane | Install WebView2 |

---

## Project files

```text
manifest.template.xml   Template — {{BASE_URL}} replaced on build
manifest.xml            Generated manifest (sideload this)
render.yaml               Render deploy config
src/taskpane/             Add-in UI
src/lib/momentkh.js       Khmer calendar library
scripts/sideload-mac.sh   Mac install helper
scripts/sideload-windows.ps1  Windows install helper
```

## Update after code changes

1. Push to GitHub → Render auto-redeploys
2. Re-download `manifest.xml` only if manifest structure changed (usually not needed for UI-only updates)
