# TaskApp Pro · repositorio por sesiones (LPS 2026–2027)

Esta es la **versión docente incremental** de TaskApp. Cada etiqueta `sesion-XX`
contiene el estado del código **al terminar la sesión**. Los pasos se reconstruyen
a partir de los apuntes locales de LPS y del proyecto original del profesor,
no son una reinterpretación de las fechas de los commits de 2025.

## Empezar

```sh
git tag --list
git switch --detach sesion-01
swift Sesion01/TaskAppConsola.swift
git switch main
```

- **main**: evolución por sesiones del curso 2026–2027.
- **legacy/2025**: historial original de TaskApp Pro de 2025, importado *sin alterar*.
- **2025-final**: etiqueta que apunta al último commit original de 2025.

El ejemplo de la sesión 1 usa diccionarios y `Date` en consola; las sesiones
posteriores incorporarán proyecto Xcode, modelo de características, SwiftUI y MVVM.

Consulta [docs/SESIONES.md](docs/SESIONES.md) para conocer el contenido y los
comandos de cada etapa. **TaskApp Pro** es el ejemplo del profesor; los equipos
trabajan con **BookApp** en la asignatura.
