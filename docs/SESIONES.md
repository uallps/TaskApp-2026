# Evolución por sesiones

La secuencia se ha establecido siguiendo los materiales locales de
`/Users/frangar/Fun/lps/modules/fundamentos/pages` y el código original
`/Users/frangar/PSI/TaskApp`, cuya rama `sesion6` coincide con
[el repositorio histórico](https://github.com/uallps/TaskApp).

| Tag | Tema | Artefacto |
|---|---|---|
| `sesion-01` | Swift básico; TaskApp de consola | `Sesion01/TaskAppConsola.swift` |
| `sesion-02` | Presentación de TaskApp Pro y la UI introductoria | Proyecto Xcode + descripción del producto |
| `sesion-03` | Modelo y diagrama de características | `Task`, `Priority`, documentación |
| `sesion-04` | Lista SwiftUI, MVVM y primer feature flag | `TaskListView`, `TaskRowView`, `AppConfig` |
| `sesion-05` | Navegación, edición mediante bindings | `TaskDetailView` y `NavigationStack` |

**Nota:** solo estas cinco sesiones están numeradas explícitamente en los
materiales que se han contrastado. Persistencia, plugins, testing y CI/CD
constan en los commits históricos posteriores y se conservan íntegros en
`archivo-2025`, pero aquí no se les asigna una sesión inventada.

## Fuentes e interpretación

- Sesión 1: `session-1-practica.adoc`, apartado “TaskApp de consola”.
- Sesión 2: `session-2-taskapp.adoc` y la introducción previa a SwiftUI.
- Sesión 3: `session-3.adoc`: características obligatorias/opcionales,
  JSON/Core Data como ejemplo de XOR.
- Sesión 4: `session-4.adoc`: `List`, MVVM, closures y flags.
- Sesión 5: `session-5.adoc`: `NavigationStack`, `@Binding` y ramas.

Los **tags de 2026 son hitos reconstruidos para impartir la asignatura**,
no commits realmente creados durante el curso 2025–2026.

## Etiquetas y ramas

```sh
git log --oneline --decorate --graph main
git tag -l
git switch --detach sesion-03
git switch main
git switch archivo-2025
```

No hagas commits estando en `detached HEAD`; crea antes una rama
(`git switch -c mi-prueba sesion-04`) si vas a experimentar.
