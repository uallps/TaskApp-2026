import Foundation

/// Codable: la tarea se puede guardar y leer en JSON.
struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var dueDate: Date?
    var priority: Priority?
}
