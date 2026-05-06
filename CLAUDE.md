# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Role & Project Context

This repository supports a **QC Engineer** working on the **E-763 Morava Corridor highway project in Serbia**.

Claude acts as a **technical assistant** for quality control engineering tasks on this infrastructure project. This includes (but is not limited to):

- Processing and analyzing QC inspection data, test results, and lab reports
- Generating checklists, reports, non-conformance reports (NCRs), and quality documentation
- Tracking material certifications, test frequencies, and compliance against standards
- Supporting workflows around earthworks, concrete, asphalt, drainage, bridges, and other highway elements

## Critical Operating Rules

- **No memory of prior sessions.** Each Claude Code session starts fresh.
- **When the user references previous work, analysis, or conversations without providing sufficient context — always ask them to paste or summarize the relevant prior content before proceeding.**
- **Do not guess or fabricate prior context.** Prioritize continuity and precision over speed.
- When in doubt about a specification, standard, or test result — flag it explicitly rather than assuming.

## Domain Conventions

- Project: **E-763 Morava Corridor**, Serbia
- Applicable standards: SRPS (Serbian standards), EN Eurocodes, PGBT (Serbian road construction technical conditions), project-specific Technical Specifications
- Units: SI (metric) — lengths in m, forces in kN, pressures in kPa/MPa
- QC documentation typically references lot numbers, chainage (stationing), layer IDs, and test dates

---

## Codebase Overview

### Files

| File | Description |
|------|-------------|
| `ConcreteQC_Dashboard.html` | Main QC dashboard — single-file HTML/CSS/JS app (~81 KB) |
| `ConcreteQC_Data.js` | Shared data file — sets `window.CONCRETE_QC_DATA` (~158 KB) |
| `ConcreteQC_Dashboard.bat` | Windows launcher — opens dashboard in Chrome as a standalone app |

### How to Run

**Windows (recommended):** Double-click `ConcreteQC_Dashboard.bat`.  
It locates Chrome and opens the dashboard as a windowed app (1500×950).  
Both files must be in the same folder; the BAT warns if `ConcreteQC_Data.js` is missing.

**Browser fallback:** Open `ConcreteQC_Dashboard.html` directly in any browser.  
The dashboard uses a `<script src="ConcreteQC_Data.js">` tag (not `fetch`) to avoid `file://` CORS restrictions.

**No build step, no server, no dependencies to install.** Chart.js and xlsx.js are loaded from CDN.

---

## Dashboard Pages

| Tab | What it shows |
|-----|---------------|
| **Overview** | Hero KPIs (total samples, pass rate, worst plant, riskiest mix), per-plant/mix stability table, action items |
| **Strength Trends** | Time-series charts per Plant+Mix — fcm, 7d/28d ratio, moving averages, control limits |
| **Failed Results** | Filterable table of FAIL records with cube details |
| **Prediction** | Early-strength prediction using 7-day results and plant-specific ratio |
| **Data Management** | Password-protected — import/export `ConcreteQC_Data.js`, add/edit records |

---

## Data Format — `ConcreteQC_Data.js`

The file assigns a global:

```js
window.CONCRETE_QC_DATA = {
  "meta": { "date": "<ISO timestamp>", "count": <total rows>, "n28": <rows with 28d result> },
  "data": [ /* array of row arrays */ ]
}
```

### Row field index mapping (object `F` in the dashboard)

| Index | Key | Description |
|-------|-----|-------------|
| 0 | `DATE` | Test date `YYYY-MM-DD` |
| 1 | `PLANT` | Batching plant name (e.g. `BEJV - 73`, `BEJV-83`) |
| 2 | `MIX` | Mix design code (e.g. `4BE02T`, `3BE11`) |
| 3 | `CLASS` | Strength class (`C25/30`, `C30/37`, `C35/45`, `C40/50`) |
| 4 | `FCK` | Characteristic strength fck,cube (MPa) |
| 5 | `TEMP` | Fresh concrete temperature (°C) |
| 6 | `SLUMP` | Slump (mm) |
| 7 | `AVG7` | Mean 7-day cube strength (MPa) |
| 8 | `AVG28` | Mean 28-day cube strength (MPa) — `null` if not yet tested |
| 9 | `DENS28` | Density at 28 days (kg/m³) |
| 10 | `FCIMIN` | Minimum individual cube at 28 days (MPa) |
| 11 | `CONFORM` | Conformity result: `"PASS"` or `"FAIL"` |
| 12 | `SLUMP_ST` | Slump status: `"PASS"` or `"FAIL"` |
| 13 | `DENSDEV` | Density deviation (unused / null in current data) |
| 14 | `RATIO` | 7d/28d strength ratio |
| 15 | `C1` | Individual cube 1 result (MPa) |
| 16 | `C2` | Individual cube 2 result (MPa) |
| 17 | `C3` | Individual cube 3 result (MPa) |

### Current dataset (as of last data export)

- **Plants:** `BEJV - 73`, `BEJV-83`
- **Total records:** 1,415 — of which **1,023 have 28-day results**
- **Date range:** 2026-01-02 onwards

### Conformity criteria (EN 206 / project spec)

```
PASS requires: fcm(3 cubes) ≥ fck,cube  AND  fci,min ≥ fck,cube − 4 MPa
```

Characteristic cube strengths (`L` object in dashboard):
- C25/30 → fck = 30 MPa
- C30/37 → fck = 37 MPa
- C35/45 → fck = 45 MPa
- C40/50 → fck = 50 MPa

---

## Key Statistics Computed by Dashboard

- **fcm(5)** — mean of last 5 cube results for a Plant+Mix
- **σ(15)** — std dev of last 15 results
- **COV** — coefficient of variation (%)
- **Margin** — fcm − fck (MPa above characteristic strength)
- **Drift** — fcm(5) − fcm(all): negative = downward trend
- **id-margin** — fci,min − (fck − 4): proximity to individual cube failure limit
- **Ratio** — 7d/28d early-strength ratio (normal range 0.65–0.75)

---

## Extending the Codebase

When adding new scripts, templates, or tools, update this file with:
- **How to run** (language, dependencies, entry point)
- **Folder structure** once files are organised
- **Data formats** and what each field represents
