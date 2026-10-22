# TaskApp histórico: correspondencia con los commits de 2025

La rama `legacy/2025` procede de la rama `sesion6` del proyecto original
en `/Users/frangar/PSI/TaskApp` y apunta exactamente al commit
`b06a1884ce6192680086ed2e316300c1e3cad73c` publicado en
[github.com/uallps/TaskApp](https://github.com/uallps/TaskApp).

**No se ha reescrito ni alterado un commit histórico**.

## Hitos de código original

| Tag en este repo | Commit 2025 | Evolución real del código |
|---|---|---|
| `hito-2025-inicio` | `a36016e` | Plantilla inicial de Xcode |
| `hito-2025-mvvm` | `06c287c` | `Task`, `TaskListViewModel`, `TaskListView`, `TaskRowView` |
| `hito-2025-navegacion` | `d6b0284` | Vista de detalle de tareas |
| `hito-2025-json` | `40a259e` | Protocolo `StorageProvider` y JSON |
| `hito-2025-swiftdata` | `ce0954a` | Persistencia con SwiftData y JSON |
| `hito-2025-plugins` | `562283e` | Plugins de datos y de UI |
| `hito-2025-tests` | `21dbb85` | Tests unitarios |
| `hito-2025-ci` | `45e253d` | Pipeline iOS/macOS |
| `hito-2025-premium` | `4526bd0` | Variante Premium con Scheme propio |
| `2025-final` | `b06a188` | Último commit original conservado |

*Estos son hitos identificados en el historial de Git, no equivalencias
certificadas con los números de sesión del curso 2025–2026*.

## Otras referencias locales

El proyecto fuente tenía dos ramas locales distintas de `sesion6`:

- `legacy/local-main-2025`: refleja el `main` del checkout local.
- `legacy/local-backup-2025`: refleja su rama `backup`.

También se conservan las guías `.adoc` que estaban presentes en el checkout
local pero no estaban registradas en Git. Están en
`legacy/2025-guias:docs/guias-locales/`, con la etiqueta
`2025-guias-locales`. No se han incluido los HTML generados.

## Relación con la rama main

Las etiquetas `sesion-01` a `sesion-05` de la **rama main** son una
reconstrucción pedagógica que respeta el orden de los apuntes de 2026.
Los hitos `hito-2025-...` apuntan a los **commits originales reales**.

Para consultar una versión antigua sin modificar la rama principal:

```sh
git switch -c estudiar-plugins hito-2025-plugins
git switch main
```
