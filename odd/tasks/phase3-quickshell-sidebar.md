# Phase 3: CestilaNixOS Quickshell Sidebar (Herdr Orchestrator & Control Center)

**Status:** Completed  
**Feature Branch:** master / current workspace  
**Created:** 2026-09-23  

## Tasks

- [x] Task 1: Create `SidebarState.qml` singleton managing drawer visibility and IPC handler (`quickshell -c cestila-shell ipc call sidebar toggle`).
- [x] Task 2: Create `Sidebar.qml` (380px width, docked to Right edge, slide-in animation, Layer Overlay).
- [x] Task 3: Implement `modules/sidebar/HerdrMonitor.qml` (Live agent cards, status pills, resource metrics, attach scratchpad action).
- [x] Task 4: Implement `modules/sidebar/NotificationCenter.qml` (Desktop notifications list with clear-all and dismiss actions).
- [x] Task 5: Implement `modules/sidebar/QuickSettings.qml` (Wi-Fi, Bluetooth, Night Light toggles, Volume/Brightness sliders, session controls).
- [x] Task 6: Wire `Sidebar {}` into `shell.qml` and connect `HerdrBadge.qml` click handler to toggle the sidebar.
- [x] Task 7: Validate QML syntax with `qmllint` and test runtime with `quickshell -p modules/home/cestila-shell/shell.qml`.
