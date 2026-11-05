import Foundation
import Observation

@Observable
final class TaskListViewModel {
    /// Cada cambio en la lista (marcar, añadir, borrar o editar en el detalle) se guarda.
    var tasks: [Task] = [
        Task(title: "Preparar clase", dueDate: Date(timeIntervalSince1970: 1_794_700_800), priority: .high),
        Task(title: "Revisar prácticas", priority: .medium),
        Task(title: "Publicar materiales")
    ] {
        didSet { save() }
    }

    @ObservationIgnored private let storageProvider: StorageProvider
    @ObservationIgnored private var loaded = false

    /// Por defecto guarda en JSON; en pruebas se le pasa un MockStorageProvider.
    init(storageProvider: StorageProvider = JSONStorageProvider()) {
        self.storageProvider = storageProvider
        _Concurrency.Task { await loadTasks() }
    }

    /// Carga las tareas guardadas, solo la primera vez que se llama.
    /// Si aún no hay fichero, se quedan las tareas de ejemplo.
    func loadTasks() async {
        guard !loaded else { return }
        loaded = true
        do {
            tasks = try await storageProvider.loadTasks()
        } catch {
            print("No se han cargado tareas: \(error)")
        }
    }

    func toggleCompletion(id: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks[index].isCompleted.toggle()
    }

    func addTask() {
        tasks.append(Task(title: "Tarea de ejemplo"))
    }

    func removeTask(id: UUID) {
        tasks.removeAll { $0.id == id }
    }

    /// La tarea con ese id, si sigue en la lista.
    func task(id: UUID) -> Task? {
        tasks.first { $0.id == id }
    }

    /// Sustituye la tarea que tiene el mismo id (la usa el detalle al editar).
    func updateTask(_ task: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index] = task
    }

    /// Guarda la lista completa. `_Concurrency.Task` es la tarea asíncrona de Swift:
    /// el nombre completo evita confundirla con nuestro modelo `Task`.
    private func save() {
        let tasks = tasks
        _Concurrency.Task {
            do {
                try await storageProvider.saveTasks(tasks: tasks)
            } catch {
                print("No se han guardado las tareas: \(error)")
            }
        }
    }
}
