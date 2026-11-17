# CestilaNixOS — Master Design Tokens
# Single source of truth derived from DESIGN.md and Google Stitch Project 5862462772584071301

{
  # Core Surface & Background Tokens
  colors = {
    # Absolute OLED black for zero-pixel emission on dark displays
    background = "#000000";
    oledPure = "#000000";

    # Tonal Dark Hierarchy
    surfaceLowest = "#050508";
    surfaceLow = "#0d0d12";     # Root background of top bar & retracted drawer
    surfaceBase = "#14141d";    # Primary container background (cards, pills, inputs)
    surfaceHigh = "#1c1c27";    # Hover states, active row selections
    surfaceElevated = "#232332";

    # Borders & Outlines
    borderSubtle = "rgba(255, 255, 255, 0.08)";
    borderFocused = "#a855f7";  # Electric Violet active focus ring
    borderMuted = "#1c1c27";

    # Electric Violet Signature Accent
    accentPrimary = "#a855f7";   # Signature Electric Violet
    accentBright = "#c084fc";    # Highlights and active hover
    accentDim = "#581c87";       # Low opacity background tint
    accentFaint = "rgba(168, 85, 247, 0.15)";

    # Semantic & Agent States (Herdr / Daemons)
    stateRunning = "#10b981";    # Terminal Emerald (Agent working / Service OK)
    stateRunningBg = "#064e3b";
    stateBlocked = "#f59e0b";    # Cyber Amber (Agent waiting for input / Warning)
    stateBlockedBg = "#78350f";
    stateCritical = "#ef4444";   # Laser Red (Build error / Agent exception)
    stateCriticalBg = "#7f1d1d";
    stateIdle = "#38bdf8";       # Sky Cyan (Agent idle / Info)
    stateIdleBg = "#0c4a6e";

    # Typography Contrast
    textPrimary = "#f8fafc";     # High contrast primary text
    textSecondary = "#94a3b8";   # Slate metadata, secondary labels
    textMuted = "#475569";       # Separators, hotkeys, placeholders
  };

  # Geometry & Radii
  geometry = {
    barHeight = 30;              # Continuous compact Top Bar height (px)
    sidebarWidth = 380;          # Herdr Drawer width (px)
    paletteWidth = 640;          # Command Palette modal width (px)
    paletteHeight = 480;

    radiusMicro = 4;             # Pills, buttons, micro-metrics (px)
    radiusCard = 6;              # Drawer cards, modals, dropdowns (px)
    radiusPill = 9999;           # Status dots & circular badges

    borderWidth = 1;             # Razor-thin 1px borders
    gutter = 8;
    padding = 10;
  };

  # Typography Scale & Font Families
  typography = {
    uiFont = "Inter, sans-serif";
    monoFont = "JetBrainsMono Nerd Font, IosevkaTerm Nerd Font, monospace";

    sizes = {
      micro = 10;                # Telemetry badges, uppercase tags
      small = 11;                # Monospace telemetry metrics, status bar labels
      base = 13;                 # Standard UI body, list titles
      medium = 14;               # Section headers, modal input text
      large = 16;                # Card headers, window titles
      title = 20;                # Modal titles
    };
  };

  # Micro-Animations
  animations = {
    fast = 120;                  # Hover feedback, button clicks (ms)
    normal = 180;                # Window focus transitions, drawer expand (ms)
    slow = 260;                  # Full workspace slide (ms)
    curve = "cubic-bezier(0.16, 1, 0.3, 1)";
  };
}
