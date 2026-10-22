import Foundation

// Sesión 3: representación del núcleo obligatorio y de las opciones.
struct Task: Identifiable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    var priority: Priority?

    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        dueDate: Date? = nil,
        priority: Priority? = nil
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.priority = priority
    }
}

enum Priority: String, CaseIterable, Identifiable, Codable {
    case low = "Baja"
    case medium = "Media"
    case high = "Alta"
    var id: String { rawValue }
}
