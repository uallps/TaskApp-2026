# Sesión 5 — Navegación y estado compartido

Pasamos de una lista de tareas a dos pantallas:

- `ContentView` crea una jerarquía `NavigationStack`.
- Desde cada fila se accede a `TaskDetailView` con un `NavigationLink`.
- El ViewModel sigue siendo el propietario de la colección.
- `List($viewModel.tasks)` proporciona un `Binding<Task>` al elemento,
  y `TaskDetailView` lo recibe con `@Binding var task: Task`.
- Cambiar el título o el estado en la pantalla de detalle modifica el
  mismo objeto de valor de la colección, actualizando automáticamente la lista.

Los botones de completar/eliminar de la fila siguen mostrando las *closures*
de la sesión 4, para ilustrar dos tipos de interacción entre vistas.

## Comprobación guiada

1. Ejecutar TaskApp y abrir un libro/tarea desde **Editar título y estado**.
2. Editar el título; volver a la lista y comprobar que se ve el nuevo texto.
3. Cambiar el estado de la tarea; comprobar que se actualiza el contador.
4. Probar de nuevo los flags de fechas y prioridades de la sesión 4.

## Git Flow (propuesta de trabajo)

La demostración de ramas de la sesión 5 se puede repetir a partir de este hito:

```sh
git switch -c feature/editar-tarea sesion-05
# Hacer cambios...
git add .
git commit -m "feat: mejora de edición"
```

Esto **no obliga** a mantener permanentemente una rama `develop` en el
repositorio docente: el ejercicio enseña el trabajo aislado en ramas.

## Pendiente respecto del TaskApp completo de 2025

Todavía no tenemos el backend de persistencia, plugins, tests de UI,
notificaciones reales ni configuración Premium. Se encuentran en la rama
`archivo-2025` del mismo nuevo repositorio con su historial auténtico.
