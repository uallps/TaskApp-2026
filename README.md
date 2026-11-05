# TaskApp 2026

Ejemplo del profesor de la asignatura Líneas de Productos Software (UAL), curso 2026-27.
Cada sesión tiene una etiqueta con el estado del código al terminarla (`sesion-3`, `sesion-4`, ...):

```sh
git clone https://github.com/uallps/TaskApp-2026.git
cd TaskApp-2026
git checkout sesion-3
```

El mismo código de la carpeta `TaskApp/` funciona en los tres sistemas:

| Sistema | Cómo se ejecuta | Interfaz |
|---|---|---|
| macOS | Abrir `TaskApp.xcodeproj` en Xcode y pulsar ▶ | SwiftUI de Apple |
| Linux | `swift run TaskApp` (necesita `libgtk-4-dev` y `libfontconfig-dev`) | [SwiftOpenUI](https://github.com/uallps/SwiftOpenUI) con GTK 4 |
| Windows | `swift run TaskApp` | SwiftOpenUI con Win32 |

En Linux y Windows, `Package.swift` añade un módulo llamado `SwiftUI` (carpeta `Compat/`)
que reexporta SwiftOpenUI, así que `import SwiftUI` funciona sin cambiar el código.

## Productos (desde la sesión 4)

| Producto | Xcode (Mac) | Linux y Windows |
|---|---|---|
| Base | scheme `TaskApp` | `swift run TaskApp` |
| Con prioridades | scheme `TaskApp Prioridades` (target con `Prioridades` en *Active Compilation Conditions*) | `swift run --traits Prioridades TaskApp` |
