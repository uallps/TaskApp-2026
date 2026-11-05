/// Almacenamiento en memoria, para pruebas y vistas previas: no escribe nada en disco.
final class MockStorageProvider: StorageProvider {
    private var storedTasks: [Task] = [
        Task(title: "Tarea de prueba 1"),
        Task(title: "Tarea de prueba 2", isCompleted: true)
    ]

    func loadTasks() async throws -> [Task] {
        storedTasks
    }

    func saveTasks(tasks: [Task]) async throws {
        storedTasks = tasks
    }
}
