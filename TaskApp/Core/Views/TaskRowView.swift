import SwiftUI

/// Fila de una tarea. No conoce el ViewModel: recibe los flags y la acción.
struct TaskRowView: View {
    let task: Task
    let showDueDates: Bool
    let showPriorities: Bool
    let toggleCompletion: () -> Void

    var body: some View {
        HStack {
            Button(action: toggleCompletion) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
            }
            .buttonStyle(.plain)
            VStack(alignment: .leading) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                if showDueDates, let dueDate = task.dueDate {
                    Text("Vence: \(dueDate.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
#if Prioridades
                if showPriorities, let priority = task.priority {
                    Text("Prioridad: \(priority.rawValue)")
                        .font(.caption)
                        .foregroundColor(priorityColor(for: priority))
                }
#endif
            }
        }
    }

#if Prioridades
    private func priorityColor(for priority: Priority) -> Color {
        switch priority {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .red
        }
    }
#endif
}
