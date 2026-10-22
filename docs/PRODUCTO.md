# Sesión 2 — Presentación de TaskApp Pro

## Alcance del ejemplo del profesor

La familia `TaskApp Pro` gestiona tareas. Su **núcleo obligatorio** es
una tarea con **título** y estado **pendiente/completada**, además de operaciones
de añadir, consultar, modificar y eliminar.

| Característica | Variabilidad |
|---|---|
| Título y estado | Común y obligatoria |
| Fecha de vencimiento | Opcional |
| Prioridad | Opcional |
| Recordatorios | Opcional, puede requerir una fecha |
| Persistencia | Decisión técnica posterior; ejemplo histórico: JSON/Core Data |

El propósito del repositorio **no es clonar una app distinta para cada
configuración**, sino evolucionar un conjunto reutilizable de componentes.

## Parte de UI de esta sesión

El proyecto Xcode empieza con una pequeña interfaz SwiftUI:
`View`, `VStack`, `Text`, `TextField`, `Button`, `@State` y `$nombre`.
Separa el estado del texto visible: cambiar `nombre` actualiza la vista.

En este hito **aún no hay Task ni listado de tareas**. En la siguiente sesión
modelaremos el dominio con tipos Swift; en la 4 conectaremos UI y modelo.

## Fuente

- `session-2-taskapp.adoc` del repositorio local LPS.
- Primer proyecto de Xcode de TaskApp en el commit `a36016e` de 2025.
- La práctica de introducción a SwiftUI precede al modelado de características.
