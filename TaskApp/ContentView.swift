import SwiftUI

// Sesión 4: List, MVVM, closures y cambios reactivos de feature flags.
struct ContentView: View {
    @StateObject private var viewModel = TaskListViewModel()
    @StateObject private var config = AppConfig()
    @State private var newTitle = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TaskApp Pro")
                .font(.largeTitle.bold())
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

            List(viewModel.tasks) { task in
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
            }
        }
        .padding()
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
