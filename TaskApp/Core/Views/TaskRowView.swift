import SwiftUI

// La fila representa una tarea. Recibe acciones, pero no conoce el ViewModel.
struct TaskRowView: View {
    let task: Task
    let showDueDates: Bool
    let showPriorities: Bool
    let onToggleCompletion: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Button(action: onToggleCompletion) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
            }
            .buttonStyle(.plain)
            .accessibilityLabel(task.isCompleted ? "Reabrir tarea" : "Completar tarea")

            VStack(alignment: .leading, spacing: 5) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)

                if showDueDates, let date = task.dueDate {
                    Text("Vence: \(date.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if showPriorities, let priority = task.priority {
                    Text("Prioridad: \(priority.rawValue)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
            Button("Eliminar", role: .destructive, action: onDelete)
                .buttonStyle(.borderless)
        }
        .padding(.vertical, 4)
    }
}
