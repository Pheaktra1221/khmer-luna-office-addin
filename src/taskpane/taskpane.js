/* global Office, momentkh */

const LUNAR_FORMAT = "ថ្ងៃW d N ខែm ឆ្នាំa e ព.ស.b";
const SOLAR_FORMAT = "ថ្ងៃទីds ខែM ឆ្នាំc";
const LABEL_STORAGE_KEY = "khmerLunaCustomLabel";
const FORMAT_STORAGE_KEY = "khmerLunaFormat";

const KH_MONTHS = ["មករា","កុម្ភៈ","មីនា","មេសា","ឧសភា","មិថុនា",
                   "កក្កដា","សីហា","កញ្ញា","តុលា","វិច្ឆិកា","ធ្នូ"];

let officeHost = "";
let activeText = "";
let currentDate = new Date();
let calYear, calMonth;
let selectedFormat = "1";

Office.onReady((info) => {
  officeHost = info.host || "";
  const saved = localStorage.getItem(FORMAT_STORAGE_KEY);
  if (saved) selectedFormat = saved;
  const savedLabel = localStorage.getItem(LABEL_STORAGE_KEY);
  if (savedLabel) document.getElementById("custom-label").value = savedLabel;

  bindUi();
  const today = new Date();
  calYear = today.getFullYear();
  calMonth = today.getMonth();
  renderCalendar();
  selectDate(today);
});

function bindUi() {
  document.getElementById("prev-month").addEventListener("click", () => { shiftMonth(-1); });
  document.getElementById("next-month").addEventListener("click", () => { shiftMonth(1); });
  document.getElementById("insert-btn").addEventListener("click", () => insertText(activeText));
  document.getElementById("copy-btn").addEventListener("click", copyActiveText);
  document.getElementById("read-selection-btn").addEventListener("click", readSelection);
  document.getElementById("custom-label").addEventListener("input", () => {
    localStorage.setItem(LABEL_STORAGE_KEY, document.getElementById("custom-label").value.trim());
    refreshPreview();
  });

  document.querySelectorAll(".pill").forEach((btn) => {
    btn.addEventListener("click", () => {
      document.querySelectorAll(".pill").forEach(p => p.classList.remove("active"));
      btn.classList.add("active");
      selectedFormat = btn.dataset.fmt;
      localStorage.setItem(FORMAT_STORAGE_KEY, selectedFormat);
      document.getElementById("label-row").classList.toggle("hidden", selectedFormat !== "4");
      refreshPreview();
    });
  });

  // restore saved format pill
  document.querySelectorAll(".pill").forEach(p => {
    p.classList.toggle("active", p.dataset.fmt === selectedFormat);
  });
  document.getElementById("label-row").classList.toggle("hidden", selectedFormat !== "4");
}

function shiftMonth(delta) {
  calMonth += delta;
  if (calMonth > 11) { calMonth = 0; calYear++; }
  if (calMonth < 0)  { calMonth = 11; calYear--; }
  renderCalendar();
}

function renderCalendar() {
  const label = `${KH_MONTHS[calMonth]} ${calYear}`;
  document.getElementById("cal-month-label").textContent = label;

  const grid = document.getElementById("cal-grid");
  grid.innerHTML = "";

  const firstDay = new Date(calYear, calMonth, 1).getDay(); // 0=Sun
  const daysInMonth = new Date(calYear, calMonth + 1, 0).getDate();
  const today = new Date();

  // empty cells before first day
  for (let i = 0; i < firstDay; i++) {
    const empty = document.createElement("div");
    empty.className = "cal-day empty";
    grid.appendChild(empty);
  }

  for (let d = 1; d <= daysInMonth; d++) {
    const date = new Date(calYear, calMonth, d);
    const cell = document.createElement("div");
    cell.className = "cal-day";
    if (date.getDay() === 0) cell.classList.add("sunday");
    if (date.getDay() === 6) cell.classList.add("saturday");

    const isToday = d === today.getDate() && calMonth === today.getMonth() && calYear === today.getFullYear();
    if (isToday) cell.classList.add("today");

    const isSel = currentDate && d === currentDate.getDate() &&
                  calMonth === currentDate.getMonth() && calYear === currentDate.getFullYear();
    if (isSel) cell.classList.add("selected");

    // Gregorian number
    const num = document.createElement("span");
    num.className = "greg-num";
    num.textContent = d;

    // Khmer lunar mini
    const luni = document.createElement("span");
    luni.className = "lunar-mini";
    try {
      const kh = momentkh.fromDate(date);
      // show lunar day number only
      luni.textContent = momentkh.format(kh, "d N");
    } catch(_) { luni.textContent = ""; }

    cell.appendChild(num);
    cell.appendChild(luni);
    cell.addEventListener("click", () => selectDate(date));
    grid.appendChild(cell);
  }
}

function selectDate(date) {
  currentDate = date;
  // re-render to update selection highlight
  if (date.getMonth() !== calMonth || date.getFullYear() !== calYear) {
    calMonth = date.getMonth();
    calYear = date.getFullYear();
  }
  renderCalendar();
  updateDateDisplay(date);
  refreshPreview();
}

function updateDateDisplay(date) {
  const kh = momentkh.fromDate(date);
  document.getElementById("kd-lunar").textContent = momentkh.format(kh, LUNAR_FORMAT);
  document.getElementById("kd-solar").textContent = momentkh.format(kh, SOLAR_FORMAT);
}

function refreshPreview() {
  if (!currentDate) return;
  const kh = momentkh.fromDate(currentDate);
  activeText = buildFormattedText(kh, selectedFormat);
  document.getElementById("preview").textContent = activeText.replace(/\r\n/g, "\n");
}

function buildFormattedText(kh, fmt) {
  const lunar = momentkh.format(kh, LUNAR_FORMAT);
  const solar = momentkh.format(kh, SOLAR_FORMAT);
  const label = document.getElementById("custom-label").value.trim();
  const labeled = label ? `${label} ${solar}` : solar;

  switch (fmt) {
    case "1": return lunar;
    case "2": return solar;
    case "3": return `${lunar}\r\n${labeled}`;
    case "4": return labeled;
    default:  return lunar;
  }
}

function readSelection() {
  Office.context.document.getSelectedDataAsync(Office.CoercionType.Text, (result) => {
    if (result.status !== Office.AsyncResultStatus.Succeeded) {
      setStatus("មិនអាចអាន cell បានទេ", true); return;
    }
    const raw = (result.value || "").trim();
    if (!raw) { setStatus("សូមជ្រើស cell ដែលមានថ្ងៃ", true); return; }
    const parsed = parseDateValue(raw);
    if (!parsed) { setStatus("cell នេះមិនមែនជាថ្ងៃទេ", true); return; }
    selectDate(parsed);
    setStatus("បានអានថ្ងៃពី cell ហើយ", false, true);
  });
}

function insertText(text) {
  if (!text) { setStatus("សូមជ្រើសថ្ងៃមុន", true); return; }
  Office.context.document.setSelectedDataAsync(text, { coercionType: Office.CoercionType.Text }, (result) => {
    if (result.status === Office.AsyncResultStatus.Succeeded) {
      setStatus("បានបញ្ចូលហើយ", false, true);
    } else {
      setStatus("បញ្ចូលមិនបាន — ចុច cell/cursor មុន", true);
    }
  });
}

async function copyActiveText() {
  if (!activeText) { setStatus("សូមជ្រើសថ្ងៃមុន", true); return; }
  try {
    await navigator.clipboard.writeText(activeText.replace(/\r\n/g, "\n"));
    setStatus("Copy ហើយ", false, true);
  } catch (_) { setStatus("Copy មិនបាន", true); }
}

function parseDateValue(value) {
  const direct = new Date(value);
  if (!Number.isNaN(direct.getTime())) return direct;
  const serial = Number(value);
  if (!Number.isNaN(serial) && serial > 20000 && serial < 80000) {
    return new Date(Date.UTC(1899, 11, 30 + serial));
  }
  const match = value.match(/^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{2,4})$/);
  if (match) {
    const year = Number(match[3].length === 2 ? `20${match[3]}` : match[3]);
    const parsed = new Date(year, Number(match[2]) - 1, Number(match[1]));
    return Number.isNaN(parsed.getTime()) ? null : parsed;
  }
  return null;
}

function setStatus(msg, isError, isSuccess) {
  const el = document.getElementById("status");
  el.textContent = msg;
  el.classList.toggle("error", Boolean(isError));
  el.classList.toggle("success", Boolean(isSuccess));
}
