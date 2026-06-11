# 🌙 Khmer Luna Date - Office Add-in

Convert Gregorian dates to Khmer lunar calendar (Chhankiteak) and insert into Word, Excel, and PowerPoint.

**Works with:** Office 2021, Microsoft 365 | **Platforms:** Windows, Mac

---

## 📥 Installation (Free)

### Windows

**Option 1: Batch installer (Easy - Double-click)**

Download: [install-windows.bat](https://raw.githubusercontent.com/Pheaktra1221/khmer-luna-office-addin/main/scripts/install-windows.bat)

Right-click → **Run as administrator** → Follow prompts

**Option 2: PowerShell installer**

Download: [install-direct-registry.ps1](https://raw.githubusercontent.com/Pheaktra1221/khmer-luna-office-addin/main/scripts/install-direct-registry.ps1)

Right-click → **Run with PowerShell**

**Option 3: One-line command**

Open PowerShell as Administrator:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; irm https://raw.githubusercontent.com/Pheaktra1221/khmer-luna-office-addin/main/scripts/install-direct-registry.ps1 | iex
```

### Mac

Download: [install-mac.sh](https://raw.githubusercontent.com/Pheaktra1221/khmer-luna-office-addin/main/scripts/install-mac.sh)

Open Terminal and run:
```bash
cd ~/Downloads
bash install-mac.sh
```

**Alternative:** Use web version at [khmer-luna-office-addin.onrender.com/taskpane/taskpane.html](https://khmer-luna-office-addin.onrender.com/taskpane/taskpane.html)

---

## ✨ Features

- 📅 **Interactive calendar** - month view with Khmer lunar dates in each cell
- 🔄 **Auto conversion** - Gregorian to Khmer lunar (Chhankiteak)
- 📝 **Multiple formats** - lunar only, solar only, both lines, custom prefix
- 📊 **Read from Excel** - convert dates directly from selected cells
- 📋 **Insert or Copy** - paste into documents or clipboard
- 🌐 **Works offline** - after initial load

---

## 🖼️ Preview

![Calendar UI](https://raw.githubusercontent.com/Pheaktra1221/khmer-luna-office-addin/main/src/assets/icon-80.png)

**Live Demo:** [Try it in browser](https://khmer-luna-office-addin.onrender.com/taskpane/taskpane.html)

---

## 🛠️ Development

```bash
npm install
npm run build
npm start
```

For production, set `BASE_URL` environment variable:
```bash
BASE_URL=https://your-domain.com npm run build
```

---

## 📦 Distribution

This add-in is distributed **free** via:
- GitHub releases with PowerShell installer
- Web version at [khmer-luna-office-addin.onrender.com](https://khmer-luna-office-addin.onrender.com/taskpane/taskpane.html)
- GitHub Pages landing: [pheaktra1221.github.io/khmer-luna-office-addin](https://pheaktra1221.github.io/khmer-luna-office-addin)

No Office Store account or AppSource submission needed.

---

## 🤝 Contributing

Issues and pull requests welcome on [GitHub](https://github.com/Pheaktra1221/khmer-luna-office-addin).

---

## 📄 License

MIT - Free for personal and commercial use

---

Made with ❤️ for Khmer Community
