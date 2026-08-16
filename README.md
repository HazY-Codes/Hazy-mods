# # HazY-mods

> **Part of HazY.Ecosystem**  
> A lightweight, POSIX-compliant Android SystemUI/UX & Layout modification suite powered by Termux and Shizuku (`rish`).

---

## Features

`hazy-mods` provides elevated ADB-level customization directly on-device—no root required, zero background battery drain, and no tripping Play Integrity or Knox flags.

* **SystemUI Control:**
  * **Precision Animation Scaler:** Set sub-0.5x transition rates (e.g., `0.25x`) for ultra-snappy UI response.
  * **Status Bar Icon Cleaner:** Dynamic interface for managing Android's `icon_blacklist` (volume, alarm, cast, bluetooth, DND, etc.).
  * **Overlay Manager:** Query and toggle system UI/theme resource overlays (`cmd overlay`).

* **Quick Settings Automation:**
  * **Layout Presets:** One-tap switching between *Minimalist*, *Power User*, *Media Focus*, and *Stock* Quick Settings layouts.
  * **Tile Injector & Backups:** Inject third-party tile components (`sysui_qs_tiles`) with session backup and undo protection.

* **Layout & Density Mods:**
  * **Dynamic DPI Scaler:** Override screen density on the fly (`wm density`) for high-space compact modes or forced tablet grids.

---

## Requirements

* **Android OS:** Android 10 or higher
* **Terminal Shell:** [Termux](https://f-droid.org/packages/com.termux/) or LADB
* **Privilege Engine:** [Shizuku](https://shizuku.rikka.app/) with `rish` configured

---

## Quick Start

Navigate to your local project folder in Termux and execute the suite:

```bash
cd /sdcard/Dev/HazY-Ecosystem/HazY-Mods
chmod +x hazy_hub.sh
sh hazy_hub.sh
