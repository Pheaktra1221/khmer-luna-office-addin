const { app, BrowserWindow } = require('electron');

const APP_URL = 'https://khmer-luna-office-addin.onrender.com/taskpane/taskpane.html';

function createWindow() {
  const win = new BrowserWindow({
    width: 480,
    height: 700,
    minWidth: 380,
    minHeight: 500,
    title: 'ថ្ងៃចន្ទគតិខ្មែរ',
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
    },
  });

  win.loadURL(APP_URL);
  win.setMenuBarVisibility(false);
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) createWindow();
});
