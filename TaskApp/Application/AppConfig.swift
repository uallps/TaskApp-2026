import Observation

/// Feature flags en ejecución: qué características muestra la app.
/// Es configuración de la aplicación, no datos de las tareas.
@Observable
final class AppConfig {
    var showDueDates = true
    var showPriorities = true
}
