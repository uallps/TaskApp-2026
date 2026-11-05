import SwiftUI

struct TaskListView: View {
    @State private var viewModel = TaskListViewModel()

    var body: some View {
        VStack {
            List(viewModel.tasks) { task in
                HStack {
                    Button {
                        viewModel.toggleCompletion(id: task.id)
                    } label: {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    }
                    .buttonStyle(.plain)
                    Text(task.title)
                }
            }
            Button("Añadir tarea") {
                viewModel.addTask()
            }
            .padding()
        }
    }
}
