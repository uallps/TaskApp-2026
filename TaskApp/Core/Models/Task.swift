import Foundation

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
    var dueDate: Date?
    var priority: Priority?
}
