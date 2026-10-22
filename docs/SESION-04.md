# Sesión 4 — SwiftUI, MVVM y primer punto de variación

En esta sesión, como en el ejemplo histórico del profesor, pasamos del
modelo al listado de tareas:

- `TaskListViewModel` conserva el estado `@Published` y gestiona el alta,
  la eliminación y el cambio de estado.
- `ContentView` tiene `@StateObject` para el ViewModel y `AppConfig`.
- `TaskRowView` representa una tarea y ejecuta las *closures* recibidas.
- `AppConfig` contiene los flags `showDueDates`, `showPriorities`
  y `enableReminders`; solo los dos primeros afectan a la interfaz.
- Los `Toggle` permiten cambiar los flags **durante la ejecución** y
  SwiftUI refleja el cambio sin recompilar.

## Comprobación

1. Aparecen tres tareas iniciales.
2. Completar o reabrir una actualiza el contador.
3. Añadir un título no vacío agrega una fila.
4. Eliminar una tarea reduce el total.
5. Desactivar *Fechas* y *Prioridades* oculta los detalles, pero el modelo
   subyacente no se borra.
6. Los recordatorios aún no están desarrollados.

No se implementan persistencia, navegación ni plugins en esta versión.
Eso pertenece a siguientes etapas.
