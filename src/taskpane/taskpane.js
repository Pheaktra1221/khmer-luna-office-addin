/* global Office, momentkh */

const LUNAR_FORMAT = "ថ្ងៃW d N ខែm ឆ្នាំa e ព.ស.b";
const SOLAR_FORMAT = "ថ្ងៃទីds ខែM ឆ្នាំc";
const LABEL_STORAGE_KEY = "khmerLunaCustomLabel";
const FORMAT_STORAGE_KEY = "khmerLunaFormat";

let officeHost = "";
let activeText = "";
let currentDate = new Date();

Office.onReady((info) => {
  officeHost = info.host || "";
  bindUi();
  loadPreferences();
  setDefaultDate(new Date());
  setStatus(getHostLabel());
});

function bindUi() {
  document.getElementById("today-btn").addEventListener("click", () => setDefaultDate(new Date()));
  document.getElementById("read-selection-btn").addEventListener("click", readSelection);
  document.getElementById("insert-btn").addEventListener("click", () => insertText(activeText));
  document.getElementById("copy-btn").addEventListener("click", copyActiveText);
  document.getElementById("gregorian-date").addEventListener("change", onDateChanged);
  document.getElementById("custom-label").addEventListener("input", onPreferencesChanged);

  document.querySelectorAll('input[name="format"]').forEach((input) => {
    input.addEventListener("change", onPreferencesChanged);
  });
}

function loadPreferences() {
  const savedLabel = localStorage.getItem(LABEL_STORAGE_KEY);
  if (savedLabel) {
    document.getElementById("custom-label").value = savedLabel;
  }

  const savedFormat = localStorage.getItem(FORMAT_STORAGE_KEY);
  if (savedFormat) {
    const input = document.querySelector(`input[name="format"][value="${savedFormat}"]`);
    if (input) {
      input.checked = true;
    }
  }
}

function onPreferencesChanged() {
  const label = document.getElementById("custom-label").value.trim();
  localStorage.setItem(LABEL_STORAGE_KEY, label);
  localStorage.setItem(FORMAT_STORAGE_KEY, getSelectedFormat());
  refreshPreview();
}

function onDateChanged() {
  const value = document.getElementById("gregorian-date").value;
  if (!value) {
    return;
  }
  const parts = value.split("-").map(Number);
  currentDate = new Date(parts[0], parts[1] - 1, parts[2]);
  refreshPreview();
}

function setDefaultDate(date) {
  document.getElementById("gregorian-date").value = formatInputDate(date);
  currentDate = date;
  refreshPreview();
}

function getSelectedFormat() {
  const selected = document.querySelector('input[name="format"]:checked');
  return selected ? selected.value : "1";
}

function getCustomLabel() {
  return document.getElementById("custom-label").value.trim();
}

function formatLunar(khmer) {
  return momentkh.format(khmer, LUNAR_FORMAT);
}

function formatSolar(khmer) {
  return momentkh.format(khmer, SOLAR_FORMAT);
}

function formatWithLabel(khmer) {
  const label = getCustomLabel();
  const solar = formatSolar(khmer);
  return label ? `${label} ${solar}` : solar;
}

function buildFormattedText(khmer, formatOption) {
  const lunar = formatLunar(khmer);
  const labeledSolar = formatWithLabel(khmer);
  const solarOnly = formatSolar(khmer);

  switch (formatOption) {
    case "1":
      return lunar;
    case "2":
      return labeledSolar;
    case "3":
      return `${lunar}\r\n${labeledSolar}`;
    case "4":
      return solarOnly;
    default:
      return lunar;
  }
}

function refreshPreview() {
  const khmer = momentkh.fromDate(currentDate);
  activeText = buildFormattedText(khmer, getSelectedFormat());
  document.getElementById("preview").textContent = activeText.replace(/\r\n/g, "\n");
}

function readSelection() {
  Office.context.document.getSelectedDataAsync(Office.CoercionType.Text, (result) => {
    if (result.status !== Office.AsyncResultStatus.Succeeded) {
      setStatus("មិនអាចអាន cell ដែលជ្រើសបានទេ", true);
      return;
    }

    const raw = (result.value || "").trim();
    if (!raw) {
      setStatus("សូមជ្រើស cell ដែលមានថ្ងៃជាមុន", true);
      return;
    }

    const parsed = parseDateValue(raw);
    if (!parsed) {
      setStatus("cell នេះមិនមែនជាថ្ងៃទេ", true);
      return;
    }

    setDefaultDate(parsed);
    setStatus("បានបំលែងថ្ងៃពី cell ហើយ", false, true);
  });
}

function insertText(text) {
  if (!text) {
    setStatus("សូមជ្រើសថ្ងៃមុន", true);
    return;
  }

  Office.context.document.setSelectedDataAsync(text, { coercionType: Office.CoercionType.Text }, (result) => {
    if (result.status === Office.AsyncResultStatus.Succeeded) {
      setStatus("បានបញ្ចូលហើយ", false, true);
      return;
    }
    setStatus("បញ្ចូលមិនបាន — ចុច cell/ទីតាំង cursor មុន", true);
  });
}

async function copyActiveText() {
  if (!activeText) {
    setStatus("សូមជ្រើសថ្ងៃមុន", true);
    return;
  }

  try {
    await navigator.clipboard.writeText(activeText.replace(/\r\n/g, "\n"));
    setStatus("Copy ហើយ", false, true);
  } catch (_error) {
    setStatus("Copy មិនបាន", true);
  }
}

function parseDateValue(value) {
  const direct = new Date(value);
  if (!Number.isNaN(direct.getTime())) {
    return direct;
  }

  const excelSerial = Number(value);
  if (!Number.isNaN(excelSerial) && excelSerial > 20000 && excelSerial < 80000) {
    return new Date(Date.UTC(1899, 11, 30 + excelSerial));
  }

  const match = value.match(/^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{2,4})$/);
  if (match) {
    const year = Number(match[3].length === 2 ? `20${match[3]}` : match[3]);
    const month = Number(match[2]);
    const day = Number(match[1]);
    const parsed = new Date(year, month - 1, day);
    return Number.isNaN(parsed.getTime()) ? null : parsed;
  }

  return null;
}

function formatInputDate(date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

function getHostLabel() {
  switch (officeHost) {
    case Office.HostType.Excel:
      return "Excel — រួចរាល់";
    case Office.HostType.Word:
      return "Word — រួចរាល់";
    case Office.HostType.PowerPoint:
      return "PowerPoint — រួចរាល់";
    default:
      return "រួចរាល់";
  }
}

function setStatus(message, isError, isSuccess) {
  const status = document.getElementById("status");
  status.textContent = message;
  status.classList.toggle("error", Boolean(isError));
  status.classList.toggle("success", Boolean(isSuccess));
}
