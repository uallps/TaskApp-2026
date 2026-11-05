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
}
