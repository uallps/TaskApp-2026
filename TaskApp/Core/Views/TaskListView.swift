import SwiftUI

struct TaskListView: View {
    @State private var viewModel = TaskListViewModel()
    @State private var config = AppConfig()

    var body: some View {
        VStack {
            HStack {
                Button("Fechas: \(config.showDueDates ? "Sí" : "No")") {
                    config.showDueDates.toggle()
                }
#if Prioridades
                Button("Prioridades: \(config.showPriorities ? "Sí" : "No")") {
                    config.showPriorities.toggle()
                }
#endif
            }
            .padding(.top)
            List(viewModel.tasks) { task in
                TaskRowView(
                    task: task,
                    showDueDates: config.showDueDates,
                    showPriorities: config.showPriorities,
                    toggleCompletion: { viewModel.toggleCompletion(id: task.id) }
                )
            }
            Button("Añadir tarea") {
                viewModel.addTask()
            }
            .padding()
        }
    }
}
