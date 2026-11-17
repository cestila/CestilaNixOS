# Design System: CestilaNixOS Developer Desktop Shell
**Project ID:** 5862462772584071301

## 1. Overview & Atmosphere: "Cyber-Minimal Precision"
CestilaNixOS is engineered as an OLED-first, hyper-focused operating system shell for software engineers working with terminal multiplexing, background tasks, and AI agent orchestration through `herdr`.

The atmosphere is uncompromisingly dark, utilitarian, and distraction-free:
- **OLED Pure Blacks (`#000000`)** eliminate visual glare and turn off display pixels.
- **Electric Violet (`#A855F7`)** serves as the single vibrant signature accent for focus, selected states, and active execution indicators.
- **Tonal Layering** replaces drop shadows: containers are differentiated through subtle dark steps (`#000000` -> `#0d0d12` -> `#14141d` -> `#1c1c27`) and razor-thin 1px borders (`rgba(255, 255, 255, 0.08)`).
- **High Information Density**: Compact heights (30px status bar), monospace telemetry metrics, and pill-shaped status badges.

---

## 2. Color Palette & Semantic Tokens

### Core Neutral & Surface Tokens
* **Pure OLED Background:** `#000000` — Absolute black canvas for root desktop and idle backdrops.
* **Surface Low:** `#0d0d12` — Root background of the continuous top bar and retracted sidebar panels.
* **Surface Base:** `#14141d` — Primary container background for cards, workspace pills, and input fields.
* **Surface High:** `#1c1c27` — Hover states, active row selections, and elevated modal panels.
* **Border Subtle:** `rgba(255, 255, 255, 0.08)` — 1px structural container separation without visual weight.
* **Border Focused:** `#A855F7` — 1px crisp active window and input focus ring.

### Accent & Identity Tokens (Electric Violet)
* **Accent Primary:** `#A855F7` — Signature Electric Violet for active workspace, primary buttons, and cursor focus.
* **Accent Highlight:** `#C084FC` — Neon glow for hover states and active tags.
* **Accent Dim:** `#581C87` — Background tint for violet badges and selection overlays (15% opacity).

### Functional & Semantic Tokens
* **State Running (Herdr / Services):** `#10B981` (Terminal Emerald) — Background `#064E3B`, text `#6EE7B7`.
* **State Blocked / Action Required:** `#F59E0B` (Cyber Amber) — Background `#78350F`, text `#FCD34D`.
* **State Critical / Error:** `#EF4444` (Laser Red) — Background `#7F1D1D`, text `#FCA5A5`.
* **State Idle / Info:** `#38BDF8` (Sky Cyan) — Background `#0C4A6E`, text `#7DD3FC`.

### Typography Colors
* **Text High Contrast:** `#F8FAFC` — Primary headings, active metrics, clock, window titles.
* **Text Secondary:** `#94A3B8` — Metadata, labels, inactive workspaces, hardware unit symbols.
* **Text Muted:** `#475569` — Separator dots, shortcuts, placeholders.

---

## 3. Typography & Font Hierarchy
* **UI Interface Font:** `Inter` (sans-serif, geometric, tight kerning).
* **Terminal & Telemetry Font:** `Iosevka Term` or `JetBrains Mono` (monospace for metrics, clock, git tags).

### Scale
* **Display / Big Numbers:** 24px–32px, ExtraBold (800), -0.02em tracking.
* **Section Headers:** 14px–16px, SemiBold (600), -0.01em tracking.
* **UI Base & Labels:** 12px–13px, Medium (500), crisp rendering.
* **Micro Telemetry / Badges:** 10px–11px, SemiBold (600), uppercase with +0.05em tracking in Monospace.

---

## 4. Geometry & Shape Language
* **Border Radii:**
  * Micro-containers & Pills: `4px` (industrial edge).
  * Cards, Flyouts & Modals: `6px` (disciplined modern curve).
  * Rounded Badges / Status Dots: Full pill / circular `9999px`.
* **Strict "No-Blur Mud" Rule:** Avoid heavy, muddy Gaussian shadows on dark surfaces. Use high-precision 1px subtle borders (`outline: 1px solid rgba(255, 255, 255, 0.08)`) and inset 1px highlights.

---

## 5. Shell Components Specification

### Component A: Continuous Compact Top Bar (30px Height)
* Full-width dark bar (`#0d0d12` with 1px bottom border `#1c1c27`).
* Left: CestilaNixOS glyph `[C*]`, Workspaces (1..5 with active pill in `#A855F7`), active window title (`ghostty: ~/CestilaNixOS`).
* Center: Clock (`14:32:05`), compact date (`Tue 22 Sep`), optional mini media player ticker.
* Right: Micro-meters (CPU `12%`, RAM `4.2G`, Temp `48°C`), Wi-Fi badge with IP tooltip, Herdr Agent Badge (`⚡ 2 Running`), Volume/Battery, Power icon.

### Component B: Collapsible Herdr & Control Sidebar (Right Drawer, 360px Width)
* Top Section: **Herdr Agent Monitor**
  * Live agent cards: Agent ID, task label, status badge (`running` green, `blocked` amber), runtime duration, CPU/RAM meter, "Attach" button.
* Middle Section: **Desktop Notifications**
  * Grouped notifications with quick-action dismiss and inline reply.
* Bottom Section: **Quick System Toggles & Sliders**
  * Wi-Fi, Bluetooth, Night Light (`hyprsunset`), Performance profile, Volume & Brightness sliders.

### Component C: Command Palette / Spotlight Launcher (640px Centered Modal)
* Floating modal with 1px Electric Violet focus border.
* Top: Large search input with fuzzy query prompt (`> Search apps, git repos, herdr tasks...`).
* Body: Results categorized with icon, title, description, and shortcut chips (`Enter: Run`, `Ctrl+E: Open in Editor`, `Ctrl+A: Attach Agent`).
