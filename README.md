# TaskApp Pro · un repositorio y cinco hitos docentes (LPS 2026–2027)

[TaskApp histórico de 2025](https://github.com/uallps/TaskApp) como referencia,
más una nueva rama `main` que reconstruye una **secuencia de clases reproducible**,
con un **tag anotado por sesión**.

## Cambiar de sesión

```sh
git tag -l 'sesion-*'
git switch --detach sesion-01
swift Sesion01/TaskAppConsola.swift

git switch --detach sesion-04
open TaskApp.xcodeproj  # SwiftUI, MVVM y feature flags

git switch --detach sesion-05
open TaskApp.xcodeproj  # NavigationStack y Binding

git switch main          # Volver a la última versión docente
```

Las sesiones **1–5** siguen el temario local de LPS 2026–2027.
Las fechas de los commits del proyecto original de 2025 **no equivalen**
automáticamente a las fechas de estas sesiones.

## Organización

- `Sesion01/`: ejercicio de consola sobre diccionarios y fechas.
- `TaskApp/`: código SwiftUI progresivo con modelo, ViewModel y vistas.
- `docs/SESIONES.md`: mapa de tags y alcance didáctico.
- `docs/FEATURE_MODEL.puml`: diagrama de características.

## Ramas y fuentes

- `main`: versión progresiva del curso actual.
- `legacy/2025`: **historial original completo**, conservado sin reescribir.
- `2025-final`: apunta a `b06a188` del TaskApp original.
- `sesion-01`…`sesion-05`: estados sucesivos de las clases.

**Importante:** las sesiones reconstruidas implementan el núcleo básico,
las opciones de fecha/prioridad y navegación. No se atribuyen a clases no
documentadas la persistencia, arquitectura de plugins, tests o CI/CD: estos
elementos sí están disponibles en la rama original 2025.

**TaskApp Pro** es la demostración del profesor. Los estudiantes realizan
las mismas actividades de ingeniería con **BookApp**.

Véase también [el mapa de sesiones](docs/SESIONES.md) y
[las características](docs/PRODUCTO.md).

## Consultar el proyecto antiguo

El historial de 2025 también está etiquetado por **hitos de código
reales**, sin adjudicarles sesiones inventadas: `hito-2025-json`,
`hito-2025-swiftdata`, `hito-2025-plugins`, `hito-2025-tests`,
`hito-2025-ci` y `hito-2025-premium`.

El detalle está en [docs/HISTORICO-2025.md](docs/HISTORICO-2025.md).
