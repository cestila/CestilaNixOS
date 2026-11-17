# CestilaNixOS — Especificación Técnica y Arquitectura del Sistema

**Versión:** 1.0.0-draft  
**Estado:** Especificación Activa — Fase de Definición  
**Target:** Sistema Operativo Declarativo para Desarrolladores (NixOS + Hyprland + Quickshell + herdr)  

---

## 1. Visión y Filosofía de Diseño

CestilaNixOS está concebido como un entorno de trabajo de alta gama para desarrolladores que operan intensivamente desde la terminal y orquestan procesos o agentes con `herdr`. 

La interfaz gráfica no es decorativa: funciona como un **HUD (Head-Up Display) de precisión**. Se rechaza la sobrecarga visual, las barras gruesas y los efectos innecesarios que consuman recursos o generen fricción cognitiva. Todo componente visual debe entregar densidad informativa útil, retroalimentación táctil instantánea y máxima legibilidad en monitores HiDPI y paneles OLED.

### Principios Fundamentales
1. **Terminal-First & Agent-Orchestrated:** El flujo de trabajo orbita alrededor de terminales rápidas (Ghostty) y sesiones persistentes coordinadas por `herdr`.
2. **OLED Ultra-Dark & Cyber-Minimal:** Fondo negro absoluto (`#000000`), superficies grises neutras profundas y acento **Electric Violet** de alto contraste para foco y estados activos.
3. **Shell Unificada en Quickshell (QML):** Eliminación de dependencias fragmentadas (Rofi, Waybar, SwayNC). Toda la shell (barra, sidebar, launcher, OSDs y notificaciones) vive en un runtime QML nativo, fluido y reactivo a IPC.
4. **Declarativo e Inmutable:** 100% configurado mediante Nix Flakes y Home-Manager, reproducible y versionado.

---

## 2. Sistema de Diseño & Tokens Visuales

### 2.1 Paleta de Color (OLED Ultra-Dark + Electric Violet)
* **Background Primario:** `#000000` (Negro puro para píxeles apagados en paneles OLED).
* **Superficies & Contenedores:**
  * `surface-lowest`: `#050508` (Fondos de paneles secundarios).
  * `surface-low`: `#0d0d12` (Cards y módulos de la barra).
  * `surface-base`: `#14141d` (Contenedores elevados, dropdowns).
  * `surface-high`: `#1c1c27` (Hover states y bordes activos).
* **Acentos (Electric Violet):**
  * `accent-primary`: `#A855F7` (Púrpura eléctrico / Violeta neón para foco y elementos activos).
  * `accent-bright`: `#C084FC` (Highlights, hover sobre acento).
  * `accent-dim`: `#581C87` (Badges pasivos, fondos de acento con baja opacidad).
* **Semántica & Estados:**
  * `state-running / success`: `#10B981` (Verde esmeralda terminal — agente herdr ejecutando / servicio OK).
  * `state-blocked / warning`: `#F59E0B` (Ámbar cálido — agente esperando input / advertencia de hardware).
  * `state-error / critical`: `#EF4444` (Rojo puro — fallo en build / batería crítica / agente caído).
  * `state-info / idle`: `#38BDF8` (Cian cielo — información / agente en reposo).
* **Tipografía & Contraste:**
  * `text-primary`: `#F8FAFC` (Blanco suave de alto contraste).
  * `text-secondary`: `#94A3B8` (Gris frío para metadatos y etiquetas secundarias).
  * `text-muted`: `#475569` (Gris tenue para separadores e iconos inactivos).

### 2.2 Tipografía
* **UI & Interfaz:** `Inter` o `Geist Sans` (geometría limpia, kerning preciso en tamaños reducidos).
* **Terminal & Código:** `IosevkaTerm Nerd Font` o `JetBrains Mono Nerd Font` (óptima densidad horizontal para tiling y scripts).

### 2.3 Geometría, Bordes y Animaciones
* **Radio de Curvatura (Borders):** Micro-redondez de **4px** a **6px** (estética industrial angular, sin bordes burbuja).
* **Bordes:** 1px con opacidades sutiles (`rgba(255, 255, 255, 0.08)`) y borde activo en `accent-primary` (`#A855F7`).
* **Animaciones (Hyprland & QML):** Curvas Bezier rápidas y precisas (duración entre **120ms** y **200ms**, sin rebotes lentos).

---

## 3. Arquitectura de la Shell (Quickshell QML)

La suite de interfaz de CestilaNixOS se implementa de manera 100% nativa en Quickshell, reemplazando la multiplicidad de herramientas externas.

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ [C*] 1 2 3 [4] 5  •  ghostty: ~/CestilaNixOS          14:32  •  CPU 12%  RAM 4.2G  [⚡ 2] ⏻ │ <- Top Bar
├──────────────────────────────────────────────────────────────────────────────┬─────────┤
│                                                                              │ HERDR   │
│                                                                              │ ─────── │
│                                                                              │ ● ag-1  │
│                               Hyprland Tiling                                │ ● ag-2  │
│                                                                              │ ─────── │
│                                                                              │ NOTIFS  │
│                                                                              │ ─────── │
│                                                                              │ TOGGLES │
└──────────────────────────────────────────────────────────────────────────────┴─────────┘
                                                                                 ^ Sidebar
```

### 3.1 Barra Superior Continua (Compact HUD)
* **Dimensiones:** Altura fija de **30px**, full-width (borde a borde), fijada al top.
* **Sección Izquierda (Contexto de Trabajo):**
  * **Distro Glyph (`[C*]`):** Isotipo vectorial de CestilaNixOS. Al click abre el Command Palette o Menú Rápido.
  * **Workspaces Hyprland:** Indicadores numéricos/pills con indicador de estado (activo, ocupado, urgente) y badge sutil si contiene terminales de agentes.
  * **Window Context:** Icono de la aplicación activa + título truncado inteligentemente.
* **Sección Central (Temporal & Media):**
  * **Clock/Calendar:** `HH:MM` en tipografía Mono. Click despliega un mini-calendario emergente y pomodoro.
  * **Media Status (dinámico):** Solo visible cuando un reproductor (MPRIS) está activo.
* **Sección Derecha (Telemetría & Agentes):**
  * **Hardware Monitor:** Micro-indicadores numéricos de consumo (CPU %, RAM, Temp C°).
  * **Red:** Wi-Fi (con icono dinámico de señal) / Ethernet. Click muestra IP local e interfaz activa.
  * **Herdr Agent Badge (`⚡ N`):** Contador de sesiones/agentes activos. Color dinámico según el estado general (verde ejecutando, ámbar esperando confirmación). Click abre el Sidebar.
  * **Audio/Volume:** Nivel en porcentaje + estado mute. Click abre el popup de control de audio.
  * **Batería:** Icono dinámico con porcentaje y tiempo restante estimado (en laptops).
  * **Control & Power:** Botón rápido para lock/shutdown.

### 3.2 Sidebar Lateral (Herdr Orchestrator & Control Center)
Panel lateral derecho desplegable vía `Super + S`, `Super + H` o click en el badge de herdr.

* **Panel Superior — Herdr Agent Monitor:**
  * Lista reactiva de sesiones y workers de `herdr`.
  * Estados por agente con indicador luminoso:
    * `idle` (reposo)
    * `running` (trabajando en una tarea)
    * `blocked` (esperando decisión/confirmación humana)
    * `error` (fallo de tarea o excepción)
  * Métrica rápida por agente: tiempo de ejecución y memoria.
  * Botón de acción por agente: **Attach Terminal Scratchpad** para abrir la sesión inmediatamente.
* **Panel Medio — Centro de Notificaciones:**
  * Notificaciones de escritorio unificadas en la misma estética OLED.
  * Agrupadas por aplicación, con botones de acción interactivos y botón "Limpiar todo".
* **Panel Inferior — Quick Settings & Toggles:**
  * Toggles de hardware: Wi-Fi, Bluetooth, Modo Noche (`hyprsunset`), No Molestar.
  * Selector de perfil de energía (Performance, Balanced, Power-saver).
  * Slider de brillo y volumen general.

### 3.3 Command Palette & Launcher (Quickshell QML)
Ventana modal centrada flotante, invocable mediante `Super + Space` o `Super + D`.
* **Motor de búsqueda difusa (Fuzzy Search):**
  * **Modo Aplicaciones:** Búsqueda y lanzamiento rápido de `.desktop` y binarios del sistema.
  * **Modo Proyectos (Git Repos):** Indexación de repositorios locales (`~/workspace`, `~/projects`) para abrir Ghostty o el editor directamente en la raíz del proyecto.
  * **Modo Herdr / AI Commands:** Ejecución directa de comandos de agentes o inicio de sesiones.
  * **Modo Portapapeles:** Historial de `cliphist` integrado con vista previa y copia instantánea.
  * **Modo Calculadora & Shell:** Evaluación matemática inline y ejecución de comandos con prefijo `>`.

### 3.4 OSDs (On-Screen Displays)
* Notificaciones visuales ultrarrápidas y centradas en pantalla para:
  * Nivel de volumen y mute.
  * Brillo de pantalla y teclado.
  * Cambio de modo de teclado / CapsLock.
  * Feedback de cambios de workspace o perfiles de energía.

---

## 4. Compositor & Experiencia de Ventanas (Hyprland)

* **Estrategia de Tiling:** `dwindle` optimizado con división inteligente según aspecto de pantalla.
* **Terminal Scratchpad Dedicado para Herdr:**
  * Atajo global (`Super + Return` o `Super + Grave`) para mostrar/ocultar una ventana flotante de Ghostty vinculada al orquestador de agentes.
  * Reglas de ventana: centrado, 80% de ancho, 75% de alto, con bordes Electric Violet y animación de deslizamiento vertical rápida.
* **Reglas de Ventana (Window Rules):**
  * Diálogos, popups y launchers siempre en modo flotante centrado.
  * Ventanas de monitoreo (`btop`, `pavucontrol`, `herdr-ui`) configuradas con dimensiones fijas ideales.
  * Inhibición de reposo (`idle_inhibit`) automático cuando hay reproducción de video o presentaciones a pantalla completa.

---

## 5. Identidad Visual, Logo & Wallpaper Engine

### 5.1 Isotipo de CestilaNixOS
* **Concepto:** Fusión geométrica entre el copo de nieve fractal de NixOS y la estética cyber-minimal:
  * Trazos angulares precisos a 60°/90°.
  * Integración de un prompt terminal (`>_`) o nodo de circuito en el núcleo central.
  * Versión monocromática con degradado sutil a Electric Violet (`#A855F7`).
* **Presencia en el Sistema:**
  * Icono en la barra de Quickshell.
  * Pantalla de login (Ly/Greetd).
  * Lockscreen con Hyprlock.
  * Arte de Fastfetch en terminal.

### 5.2 Motor de Wallpapers & Curaduría
* **Backend:** `swww` para transiciones fluidas de imagen sin bloqueo de frames.
* **Colección Curada OLED Ultra-Dark:**
  * Conjunto estructurado de fondos 4K con >70% de negros puros (`#000000`).
  * Categorías: Cyberpunk Wireframes, Brutalismo Arquitectónico, Topografía y Renders Geométricos.
* **Wallpaper Picker GUI:**
  * Módulo en el Sidebar de Quickshell o modal flotante con grilla de miniaturas generadas dinámicamente y previsualización en tiempo real.

---

## 6. Herramientas de Gestión & Configuración del Sistema

* **CLI (`cnixcli`):**
  * `cnixcli switch` / `cnixcli boot`: Rebuild y switch de flake con reporte visual de cambios.
  * `cnixcli update`: Actualización de inputs del flake con validación de lockfile.
  * `cnixcli clean`: Limpieza declarativa de generaciones antiguas y garbage collection del Nix store.
  * `cnixcli info`: Diagnóstico del sistema y estado de drivers (NVIDIA/AMD, kernels, servicios).
* **Settings GUI (Quickshell Modal):**
  * Ajustes rápidos de personalización (wallpaper, acento de color, comportamiento de la barra, monitores).

---

## 7. Plan de Ejecución por Fases (Phased Roadmap)

El desarrollo del sistema se estructura en 7 fases secuenciales para garantizar calidad arquitectónica en cada entrega:

```
[Fase 0: Blueprint & Prototipado en Stitch]
   ↓
[Fase 1: Motor del Design System en NixOS (Theme.qml & Tokens)]
   ↓
[Fase 2: Quickshell Top Bar Continua (HUD Compacto)]
   ↓
[Fase 3: Quickshell Sidebar (Herdr Orchestrator & Control Center)]
   ↓
[Fase 4: Quickshell Command Palette & Launcher]
   ↓
[Fase 5: Hyprland Workspace, Scratchpads & Ergonomía de Teclado]
   ↓
[Fase 6: Identidad Visual, Wallpapers & Polish Final]
```

### Detalle de las Fases:
* **Fase 0 — Blueprint & Prototipado Stitch:**
  * Crear proyecto en Google Stitch: `CestilaNixOS - Desktop Shell`.
  * Generar `DESIGN.md` con los tokens de diseño formalizados.
  * Prototipar visualmente las pantallas en Stitch (Top Bar, Sidebar con herdr, Command Palette, OSDs).
* **Fase 1 — Motor del Design System en NixOS:**
  * Crear `Theme.qml` centralizado en Quickshell con los tokens de Stitch.
  * Configurar variables globales en Home-Manager para sincronizar terminales (Ghostty) y editores con la paleta.
* **Fase 2 — Quickshell Top Bar Continua:**
  * Maquetar e implementar la barra superior continua de 30px en QML.
  * Integrar módulos de workspaces, título activo, telemetría de hardware y tray.
* **Fase 3 — Quickshell Sidebar (Herdr & Control Center):**
  * Crear el panel lateral retráctil.
  * Conectar la API/IPC de `herdr` para monitoreo de agentes en tiempo real.
  * Implementar centro de notificaciones y quick toggles.
* **Fase 4 — Quickshell Command Palette:**
  * Desarrollar el buscador modal fuzzy en QML.
  * Integrar lanzador de apps, buscador de proyectos Git, comandos de agentes y portapapeles.
* **Fase 5 — Hyprland Ergonomics & Scratchpads:**
  * Pulir `hyprland.nix` y `binds.nix`: animaciones, scratchpads para herdr/Ghostty y reglas de ventanas.
* **Fase 6 — Identidad Visual, Wallpapers & Polish:**
  * Diseñar e incorporar el isotipo vectorial en boot, lockscreen, barra y fastfetch.
  * Empaquetar la colección de wallpapers OLED y configurar el selector dinámico con `swww`.
* **Fase 7 — Auditoría, Verificación & Documentación:**
  * Pruebas de integración, verificación de consumo de memoria y build de Nix Flake limpio.
