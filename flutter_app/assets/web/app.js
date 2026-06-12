/* Khmer Luna Date - Standalone App (no Office.js) */
const LUNAR_FORMAT = "ថ្ងៃW d N ខែm ឆ្នាំa e ព.ស.b";
const SOLAR_FORMAT  = "ថ្ងៃទីds ខែM ឆ្នាំc";
const KH_MONTHS = ["មករា","កុម្ភៈ","មីនា","មេសា","ឧសភា","មិថុនា",
                    "កក្កដា","សីហា","កញ្ញា","តុលា","វិច្ឆិកា","ធ្នូ"];

let activeText = "", currentDate = new Date();
let calYear = currentDate.getFullYear(), calMonth = currentDate.getMonth();
let selectedFormat = localStorage.getItem("fmt") || "1";

window.addEventListener("DOMContentLoaded", () => {
  // Restore saved format
  document.querySelectorAll(".pill").forEach(p => {
    p.classList.toggle("active", p.dataset.fmt === selectedFormat);
  });
  document.getElementById("label-row").classList.toggle("hidden", selectedFormat !== "4");

  bindUi();
  renderCalendar();
  selectDate(currentDate);
});

function bindUi() {
  document.getElementById("prev-month").addEventListener("click", () => shiftMonth(-1));
  document.getElementById("next-month").addEventListener("click", () => shiftMonth(1));
  document.getElementById("copy-btn").addEventListener("click", copyText);
  document.getElementById("share-btn").addEventListener("click", shareText);
  document.getElementById("custom-label").addEventListener("input", refreshPreview);

  document.querySelectorAll(".pill").forEach(btn => {
    btn.addEventListener("click", () => {
      document.querySelectorAll(".pill").forEach(p => p.classList.remove("active"));
      btn.classList.add("active");
      selectedFormat = btn.dataset.fmt;
      localStorage.setItem("fmt", selectedFormat);
      document.getElementById("label-row").classList.toggle("hidden", selectedFormat !== "4");
      refreshPreview();
    });
  });
}

function shiftMonth(d) {
  calMonth += d;
  if (calMonth > 11) { calMonth = 0; calYear++; }
  if (calMonth < 0)  { calMonth = 11; calYear--; }
  renderCalendar();
}

function renderCalendar() {
  document.getElementById("cal-month-label").textContent = `${KH_MONTHS[calMonth]} ${calYear}`;
  const grid = document.getElementById("cal-grid");
  grid.innerHTML = "";
  const firstDay = new Date(calYear, calMonth, 1).getDay();
  const daysInMonth = new Date(calYear, calMonth + 1, 0).getDate();
  const today = new Date();

  for (let i = 0; i < firstDay; i++) {
    const e = document.createElement("div");
    e.className = "cal-day empty";
    grid.appendChild(e);
  }

  for (let d = 1; d <= daysInMonth; d++) {
    const date = new Date(calYear, calMonth, d);
    const cell = document.createElement("div");
    cell.className = "cal-day";
    if (date.getDay() === 0) cell.classList.add("sunday");
    if (date.getDay() === 6) cell.classList.add("saturday");
    if (d === today.getDate() && calMonth === today.getMonth() && calYear === today.getFullYear())
      cell.classList.add("today");
    if (currentDate && d === currentDate.getDate() &&
        calMonth === currentDate.getMonth() && calYear === currentDate.getFullYear())
      cell.classList.add("selected");

    const num = document.createElement("span");
    num.className = "greg-num";
    num.textContent = d;

    const luni = document.createElement("span");
    luni.className = "lunar-mini";
    try { luni.textContent = momentkh.format(momentkh.fromDate(date), "d N"); } catch(_) {}

    cell.appendChild(num);
    cell.appendChild(luni);
    cell.addEventListener("click", () => selectDate(date));
    grid.appendChild(cell);
  }
}

function selectDate(date) {
  currentDate = date;
  if (date.getMonth() !== calMonth || date.getFullYear() !== calYear) {
    calMonth = date.getMonth();
    calYear = date.getFullYear();
  }
  renderCalendar();
  const kh = momentkh.fromDate(date);
  document.getElementById("kd-lunar").textContent = momentkh.format(kh, LUNAR_FORMAT);
  document.getElementById("kd-solar").textContent  = momentkh.format(kh, SOLAR_FORMAT);
  refreshPreview();
}

function refreshPreview() {
  if (!currentDate) return;
  const kh     = momentkh.fromDate(currentDate);
  const lunar  = momentkh.format(kh, LUNAR_FORMAT);
  const solar  = momentkh.format(kh, SOLAR_FORMAT);
  const label  = (document.getElementById("custom-label").value || "").trim();
  const labeled = label ? `${label} ${solar}` : solar;

  switch (selectedFormat) {
    case "1": activeText = lunar;              break;
    case "2": activeText = solar;              break;
    case "3": activeText = `${lunar}\n${labeled}`; break;
    case "4": activeText = labeled;            break;
    default:  activeText = lunar;
  }
  document.getElementById("preview").textContent = activeText;
}

function copyText() {
  if (!activeText) return;
  // Try Flutter bridge first (mobile), fallback to clipboard API (desktop/web)
  if (window.flutter_inappwebview) {
    window.flutter_inappwebview.callHandler('copyText', activeText);
    setStatus("Copy ហើយ ✓", true);
  } else {
    navigator.clipboard.writeText(activeText)
      .then(() => setStatus("Copy ហើយ ✓", true))
      .catch(() => setStatus("Copy មិនបាន", false));
  }
}

function shareText() {
  if (!activeText) return;
  if (navigator.share) {
    navigator.share({ text: activeText }).catch(() => {});
  } else {
    copyText();
  }
}

function setStatus(msg, ok) {
  const el = document.getElementById("status");
  el.textContent = msg;
  el.className = "status " + (ok ? "success" : "error");
  setTimeout(() => { el.textContent = ""; el.className = "status"; }, 2000);
}
