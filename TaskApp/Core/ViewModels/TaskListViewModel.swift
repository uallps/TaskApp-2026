import Foundation
import Combine

@MainActor
final class TaskListViewModel: ObservableObject {
    @Published var tasks: [Task] = [
        Task(
            title: "Comprar leche",
            dueDate: Date(timeIntervalSince1970: 1_794_700_800),
            priority: .high
        ),
        Task(title: "Hacer ejercicio", priority: .medium),
        Task(title: "Llamar a mamá")
    ]

    @discardableResult
    func addTask(title: String) -> Bool {
        let title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return false }
        tasks.append(Task(title: title))
        return true
    }

    func toggleCompletion(id: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks[index].isCompleted.toggle()
    }

    func deleteTask(id: UUID) {
        tasks.removeAll { $0.id == id }
    }

    var completedCount: Int { tasks.filter(\.isCompleted).count }
}
