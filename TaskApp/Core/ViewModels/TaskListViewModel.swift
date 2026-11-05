import Foundation
import Observation

@Observable
final class TaskListViewModel {
    var tasks: [Task] = [
        Task(title: "Preparar clase", dueDate: Date(timeIntervalSince1970: 1_794_700_800), priority: .high),
        Task(title: "Revisar prácticas", priority: .medium),
        Task(title: "Publicar materiales")
    ]

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
}
