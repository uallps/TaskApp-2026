# TaskApp Pro · repositorio por sesiones (LPS 2026–2027)

Un único ejemplo de profesor que progresa mediante **un commit y un tag
anotado por sesión**. Los estados se han reconstruido a partir de los apuntes
locales de LPS y del TaskApp histórico de 2025.

```sh
git tag --list
git switch --detach sesion-01
swift Sesion01/TaskAppConsola.swift

git switch --detach sesion-02
open TaskApp.xcodeproj

git switch main
```

- **main**: los cinco hitos docentes reconstruidos, que crecen de forma lineal.
- **legacy/2025**: los commits originales de 2025, sin cambios.
- **2025-final**: etiqueta del último commit histórico de 2025.

**TaskApp Pro** es el ejemplo común del profesor; los grupos desarrollan
**BookApp**. Consulta [docs/SESIONES.md](docs/SESIONES.md) y
[docs/PRODUCTO.md](docs/PRODUCTO.md).
