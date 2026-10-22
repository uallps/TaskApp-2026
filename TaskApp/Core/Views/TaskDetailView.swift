import SwiftUI

// Sesión 5: la vista de detalle edita la tarea que conserva la lista.
// No mantiene una segunda copia de la misma tarea.
struct TaskDetailView: View {
    @Binding var task: Task

    var body: some View {
        Form {
            TextField("Título", text: $task.title)
            Toggle("Completada", isOn: $task.isCompleted)

            if let dueDate = task.dueDate {
                LabeledContent(
                    "Vencimiento",
                    value: dueDate.formatted(date: .abbreviated, time: .omitted)
                )
            }
            if let priority = task.priority {
                LabeledContent("Prioridad", value: priority.rawValue)
            }
        }
        .navigationTitle("Detalle de la tarea")
    }
}
