import SwiftUI

// Sesión 5: NavigationStack + detalle editable con un Binding<Task>.
struct ContentView: View {
    @StateObject private var viewModel = TaskListViewModel()
    @StateObject private var config = AppConfig()
    @State private var newTitle = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("\(viewModel.tasks.count) tareas · \(viewModel.completedCount) completadas")
                    .foregroundStyle(.secondary)

                HStack {
                    TextField("Nueva tarea", text: $newTitle)
                        .textFieldStyle(.roundedBorder)
                    Button("Añadir") { addTask() }
                        .buttonStyle(.borderedProminent)
                }

                HStack {
                    Toggle("Fechas", isOn: $config.showDueDates)
                    Toggle("Prioridades", isOn: $config.showPriorities)
                }

                List($viewModel.tasks) { $task in
                    VStack(alignment: .leading, spacing: 8) {
                        TaskRowView(
                            task: task,
                            showDueDates: config.showDueDates,
                            showPriorities: config.showPriorities,
                            onToggleCompletion: {
                                viewModel.toggleCompletion(id: task.id)
                            },
                            onDelete: {
                                viewModel.deleteTask(id: task.id)
                            }
                        )

                        NavigationLink("Editar título y estado") {
                            TaskDetailView(task: $task)
                        }
                        .font(.caption)
                    }
                }
            }
            .padding()
            .navigationTitle("TaskApp Pro")
        }
    }

    private func addTask() {
        if viewModel.addTask(title: newTitle) {
            newTitle = ""
        }
    }
}

#Preview {
    ContentView()
}
