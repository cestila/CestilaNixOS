[English](cnixcli.md) | [Español](cnixcli.es.md)

# Utilidad de Línea de Comandos CestilaNixOS (cnixcli) - Versión 1.0.2

`cnixcli` es una herramienta práctica para realizar tareas comunes de mantenimiento en tu sistema CestilaNixOS con un solo comando. A continuación, una guía de uso y comandos.

## Uso

Ejecuta la utilidad con un comando específico:

`cnixcli`

Si no se proporciona comando, muestra la ayuda.

## Comandos Disponibles (resumen)

| Comando       | Icono | Descripción                                                                                 | Ejemplo                              |
| ------------- | ----- | ------------------------------------------------------------------------------------------- | ------------------------------------ |
| cleanup       | 🧹    | Elimina generaciones antiguas (todas o manteniendo N últimas)                               | `cnixcli cleanup`                       |
| diag          | 🛠️    | Genera informe de diagnóstico en `~/diag.txt`                                               | `cnixcli diag`                          |
| list-gens     | 📋    | Lista generaciones de usuario y sistema                                                      | `cnixcli list-gens`                     |
| rebuild       | 🔨    | Reconstruye NixOS (con comprobaciones de seguridad previas)                                  | `cnixcli rebuild -v`                    |
| rebuild-boot  | 🔄    | Reconstruye para el próximo arranque (más seguro para cambios grandes)                       | `cnixcli rebuild-boot`                  |
| trim          | ✂️    | Ejecuta fstrim del sistema de archivos                                                       | `cnixcli trim`                          |
| update        | 🔄    | Actualiza el flake y reconstruye                                                             | `cnixcli update`                        |
| update-host   | 🏠    | Ajusta host y perfil en `flake.nix` (detección de GPU y validación)                          | `cnixcli update-host`                   |
| add-host      | ➕    | Crea un nuevo host (detección de GPU, `hardware.nix`, integración git)                       | `cnixcli add-host mi-host amd`          |
| del-host      | ➖    | Elimina un host existente                                                                     | `cnixcli del-host mi-host`              |
| doom install  | 🔥    | Instala Doom Emacs usando el script `get-doom`                                               | `cnixcli doom install`                  |
| doom status   | ✅    | Comprueba instalación y muestra versión                                                      | `cnixcli doom status`                   |
| doom remove   | 🗑️    | Elimina Doom Emacs con confirmación                                                          | `cnixcli doom remove`                   |
| doom update   | 🔄    | Actualiza paquetes/config de Doom (`doom sync`)                                              | `cnixcli doom update`                   |

## Opciones Avanzadas (rebuild/update)

- `--dry, -n`: simulación (no ejecuta)
- `--ask, -a`: confirmación interactiva
- `--cores N`: limita CPU usada en compilación
- `--verbose, -v`: salida detallada
- `--no-nom`: deshabilita nix-output-monitor

### Ejemplos
```bash
cnixcli update --dry
cnixcli rebuild --ask --verbose
cnixcli rebuild --cores 2
cnixcli update --dry --verbose --cores 4
```

## Notas

- Usa `update-host`, `add-host` y `del-host` para gestionar hosts.
- Doom Emacs: `install`, `status`, `remove`, `update` para ciclo de vida.
- Si tienes problemas, genera `cnixcli diag` y revisa los logs del sistema.
