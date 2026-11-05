import SwiftUI

/// Detalle de una tarea. Recibe un enlace (@Binding) a la tarea de la lista:
/// lo que se edita aquí cambia la tarea del ViewModel, sin copias.
struct TaskDetailView: View {
    @Binding var task: Task

    var body: some View {
        Form {
            TextField("Título de la tarea", text: $task.title)
            Toggle("Completada", isOn: $task.isCompleted)
        }
        .navigationTitle(task.title)
    }
}
