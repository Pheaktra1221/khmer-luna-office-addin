const fs = require("fs");
const path = require("path");

const source = path.join(__dirname, "..", "node_modules", "@thyrith", "momentkh", "momentkh.js");
const targetDir = path.join(__dirname, "..", "src", "lib");
const target = path.join(targetDir, "momentkh.js");

if (!fs.existsSync(source)) {
  console.error("momentkh.js not found. Run npm install first.");
  process.exit(1);
}

fs.mkdirSync(targetDir, { recursive: true });
fs.copyFileSync(source, target);
console.log("Copied momentkh.js to src/lib/");
