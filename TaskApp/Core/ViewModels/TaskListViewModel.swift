import Foundation
import Observation

@Observable
final class TaskListViewModel {
    var tasks: [Task] = [
        Task(title: "Preparar clase"),
        Task(title: "Revisar prácticas"),
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
