/// Contrato de almacenamiento de tareas. El ViewModel solo conoce este protocolo,
/// así que se puede cambiar dónde se guardan las tareas sin tocarlo.
protocol StorageProvider {
    func loadTasks() async throws -> [Task]
    func saveTasks(tasks: [Task]) async throws
}
