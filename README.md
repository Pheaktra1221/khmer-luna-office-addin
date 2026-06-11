# Khmer Luna Date — Office Add-in

Khmer lunar (Chhankiteak) dates for **Excel, Word, PowerPoint** — **Office 2021**, non-365, **Mac & Windows**.

**Full step-by-step guide:** see [SETUP.md](./SETUP.md)

## Quick links

- **4 formats:** lunar only, label+solar, both lines, solar only
- **Custom label:** change `ផ្លូវមាស` to anything in the task pane
- **Host on Render:** `render.yaml` included — push to GitHub, deploy on Render
- **Calendar:** [@thyrith/momentkh](https://github.com/ThyrithSor/momentkh)

## Deploy to Render (summary)

1. Push this folder to GitHub
2. Create Render web service from repo (uses `render.yaml`)
3. Download `https://YOUR-APP.onrender.com/manifest.xml`
4. Sideload manifest on Mac or Windows (see SETUP.md)

## Local dev

```bash
npm install
npm start
npm run sideload:mac      # Mac
npm run sideload:windows  # Windows
```
