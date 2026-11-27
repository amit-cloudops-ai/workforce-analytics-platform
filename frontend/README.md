# frontend/ (Workstream C)

Static SPA: plain HTML/CSS/JS modules, Chart.js + D3 from CDN (pinned, with SRI). No build step. Tabs: Overview (charts, health), Attrition, Org chart.
`config.json` is **generated at deploy** from Terraform outputs and is git-ignored. `?mock=1` loads `frontend/mock/*.json`.

**Visual direction must be approved by the lead before UI work starts** (WFA-007). Issues WFA-026..031, 033.
