import SwiftCrossUI
import DefaultBackend
import TaskAppCore

@main
struct TaskAppCrossUI: App {
    var body: some Scene {
        WindowGroup("TaskApp") {
            TaskCrossView()
        }
    }
}

struct TaskCrossView: View {
    @State var board = TaskBoard.demo()
    @State var draft = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("TaskApp")
            Text("\(board.tasks.count) tareas · \(board.completedCount) completadas")

            HStack {
                TextField("Nueva tarea", text: $draft)
                Button("Añadir") {
                    var updated = board
                    if updated.add(draft) {
                        board = updated
                        draft = ""
                    }
                }
            }

            HStack {
                Button("Fechas: \(board.features.showDueDates ? "Sí" : "No")") {
                    var updated = board
                    updated.features.showDueDates.toggle()
                    board = updated
                }
                Button("Prioridades: \(board.features.showPriorities ? "Sí" : "No")") {
                    var updated = board
                    updated.features.showPriorities.toggle()
                    board = updated
                }
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(board.rows) { row in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(row.title)
                            Text(row.status)
                            if let due = row.dueDate {
                                Text("Vence: \(due)")
                            }
                            if let priority = row.priority {
                                Text("Prioridad: \(priority)")
                            }
                            HStack {
                                Button(row.isCompleted ? "Reabrir" : "Completar") {
                                    var updated = board
                                    updated.toggle(row.id)
                                    board = updated
                                }
                                .frame(minWidth: 100)
                                Button("Eliminar") {
                                    var updated = board
                                    updated.delete(row.id)
                                    board = updated
                                }
                                .frame(minWidth: 100)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}
