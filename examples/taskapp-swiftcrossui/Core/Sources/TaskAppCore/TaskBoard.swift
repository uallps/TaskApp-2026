import Foundation

public enum Priority: String, CaseIterable, Codable, Sendable {
    case low = "Baja"
    case medium = "Media"
    case high = "Alta"
}

public struct Task: Identifiable, Equatable, Codable, Sendable {
    public let id: UUID
    public var title: String
    public var isCompleted: Bool
    public var dueDate: Date?
    public var priority: Priority?

    public init(
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

public struct TaskFeatures: Equatable, Sendable {
    public var showDueDates: Bool
    public var showPriorities: Bool

    public init(showDueDates: Bool, showPriorities: Bool) {
        self.showDueDates = showDueDates
        self.showPriorities = showPriorities
    }

    public static let basic = TaskFeatures(showDueDates: false, showPriorities: false)
    public static let pro = TaskFeatures(showDueDates: true, showPriorities: true)
}

// Display data is derived from the same rules in both frontends.
public struct TaskRow: Identifiable, Equatable, Codable, Sendable {
    public let id: UUID
    public let title: String
    public let isCompleted: Bool
    public let status: String
    public let dueDate: String?
    public let priority: String?
}

public struct TaskBoard: Equatable, Sendable {
    public private(set) var tasks: [Task]
    public var features: TaskFeatures

    public init(tasks: [Task] = [], features: TaskFeatures = .pro) {
        self.tasks = tasks
        self.features = features
    }

    @discardableResult
    public mutating func add(_ rawTitle: String, id: UUID = UUID()) -> Bool {
        let title = rawTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return false }
        tasks.append(Task(id: id, title: title))
        return true
    }

    @discardableResult
    public mutating func toggle(_ id: UUID) -> Bool {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return false }
        tasks[index].isCompleted.toggle()
        return true
    }

    @discardableResult
    public mutating func delete(_ id: UUID) -> Bool {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return false }
        tasks.remove(at: index)
        return true
    }

    public var completedCount: Int {
        tasks.filter(\.isCompleted).count
    }

    public var rows: [TaskRow] {
        tasks.map { task in
            let dateString: String?
            if features.showDueDates, let date = task.dueDate {
                let formatter = ISO8601DateFormatter()
                formatter.timeZone = TimeZone(secondsFromGMT: 0)!
                formatter.formatOptions = [.withFullDate]
                dateString = formatter.string(from: date)
            } else {
                dateString = nil
            }
            return TaskRow(
                id: task.id,
                title: task.title,
                isCompleted: task.isCompleted,
                status: task.isCompleted ? "Completada" : "Pendiente",
                dueDate: dateString,
                priority: features.showPriorities ? task.priority?.rawValue : nil
            )
        }
    }

    public static func demo() -> TaskBoard {
        TaskBoard(tasks: [
            Task(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                title: "Comprar leche",
                dueDate: Date(timeIntervalSince1970: 1_794_700_800),
                priority: .high
            ),
            Task(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                title: "Hacer ejercicio",
                priority: .medium
            ),
            Task(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
                title: "Llamar a mamá"
            )
        ])
    }
}
