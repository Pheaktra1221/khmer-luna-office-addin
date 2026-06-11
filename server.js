const express = require("express");
const https = require("https");
const path = require("path");

const PORT = process.env.PORT || 3000;
const ROOT = path.join(__dirname, "src");
const isProduction = process.env.NODE_ENV === "production" || Boolean(process.env.RENDER);

function createApp() {
  const app = express();
  app.use(express.static(ROOT));
  app.get("/manifest.xml", (_req, res) => {
    res.sendFile(path.join(__dirname, "manifest.xml"));
  });
  app.get("/health", (_req, res) => {
    res.json({ ok: true });
  });
  return app;
}

async function startDevServer() {
  const devCerts = require("office-addin-dev-certs");
  await devCerts.ensureCertificatesAreInstalled();
  const options = await devCerts.getHttpsServerOptions();
  const app = createApp();

  https.createServer(options, app).listen(PORT, () => {
    console.log(`Khmer Luna add-in running at https://localhost:${PORT}`);
    console.log("Task pane: https://localhost:3000/taskpane/taskpane.html");
    console.log("Keep this server running while using the add-in in Office.");
  });
}

function startProductionServer() {
  const app = createApp();
  app.listen(PORT, () => {
    console.log(`Khmer Luna add-in running on port ${PORT}`);
  });
}

if (isProduction) {
  startProductionServer();
} else {
  startDevServer().catch((error) => {
    console.error("Failed to start HTTPS server:", error);
    process.exit(1);
  });
}
