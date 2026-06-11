const fs = require("fs");
const path = require("path");

const root = path.join(__dirname, "..");
const templatePath = path.join(root, "manifest.template.xml");
const baseUrl = (
  process.env.RENDER_EXTERNAL_URL ||
  process.env.BASE_URL ||
  "https://localhost:3000"
).replace(/\/$/, "");

const manifest = fs
  .readFileSync(templatePath, "utf8")
  .replace(/\{\{BASE_URL\}\}/g, baseUrl);

fs.writeFileSync(path.join(root, "manifest.xml"), manifest, "utf8");
fs.writeFileSync(path.join(root, "src", "manifest.xml"), manifest, "utf8");

console.log(`manifest.xml updated for ${baseUrl}`);
