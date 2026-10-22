import SwiftUI
import TaskAppCore

@main
struct TaskAppSwiftUI: App {
    var body: some Scene {
        WindowGroup("TaskApp") {
            TaskSwiftUIView()
        }
    }
}

struct TaskSwiftUIView: View {
    @State private var board = TaskBoard.demo()
    @State private var draft = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("TaskApp").font(.largeTitle.bold())
            Text("\(board.tasks.count) tareas · \(board.completedCount) completadas")

            HStack {
                TextField("Nueva tarea", text: $draft)
                    .textFieldStyle(.roundedBorder)
                Button("Añadir", action: addTask)
            }

            HStack {
                Button("Fechas: \(board.features.showDueDates ? "Sí" : "No")") {
                    board.features.showDueDates.toggle()
                }
                Button("Prioridades: \(board.features.showPriorities ? "Sí" : "No")") {
                    board.features.showPriorities.toggle()
                }
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(board.rows) { row in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(row.title).font(.headline)
                                Text(row.status).foregroundStyle(.secondary)
                                if let due = row.dueDate {
                                    Text("Vence: \(due)").font(.caption)
                                }
                                if let priority = row.priority {
                                    Text("Prioridad: \(priority)").font(.caption)
                                }
                            }
                            Spacer()
                            Button(row.isCompleted ? "Reabrir" : "Completar") {
                                board.toggle(row.id)
                            }
                            Button("Eliminar") {
                                board.delete(row.id)
                            }
                        }
                        Divider()
                    }
                }
            }
        }
        .padding(20)
        .frame(minWidth: 600, minHeight: 420)
    }

    private func addTask() {
        if board.add(draft) {
            draft = ""
        }
    }
}
