import SwiftUI

struct TaskListView: View {
    @State private var viewModel = TaskListViewModel()
    @State private var config = AppConfig()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.tasks) { task in
                    taskRow(task: task)
                }
            }
            .toolbar {
                Button("Fechas: \(config.showDueDates ? "Sí" : "No")") {
                    config.showDueDates.toggle()
                }
#if Prioridades
                Button("Prioridades: \(config.showPriorities ? "Sí" : "No")") {
                    config.showPriorities.toggle()
                }
#endif
                Button("Añadir tarea") {
                    viewModel.addTask()
                }
            }
            .navigationTitle("Tareas")
        }
    }

    /// Una fila: enlace al detalle de la tarea, con menú contextual para borrarla.
    private func taskRow(task: Task) -> some View {
        NavigationLink(destination: TaskDetailView(task: binding(for: task))) {
            TaskRowView(
                task: task,
                showDueDates: config.showDueDates,
                showPriorities: config.showPriorities,
                toggleCompletion: { viewModel.toggleCompletion(id: task.id) }
            )
            .contextMenu {
                Button("Eliminar tarea") {
                    viewModel.removeTask(id: task.id)
                }
            }
        }
    }

    /// Un enlace (Binding) para que el detalle edite la tarea. No toca los datos:
    /// leer y escribir se traducen a métodos del ViewModel.
    private func binding(for task: Task) -> Binding<Task> {
        Binding(
            get: { viewModel.task(id: task.id) ?? task },
            set: { viewModel.updateTask($0) }
        )
    }
}
