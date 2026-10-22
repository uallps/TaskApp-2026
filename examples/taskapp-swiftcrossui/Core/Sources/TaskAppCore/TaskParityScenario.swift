import Foundation

public struct TaskParitySnapshot: Encodable, Sendable {
    public let initial: [TaskRow]
    public let after: [TaskRow]
    public let total: Int
    public let completed: Int
    public let added: Bool
    public let toggled: Bool
    public let deleted: Bool
}

// Reproducible actions to compare macOS and Linux results byte-for-byte.
public func runTaskParityScenario() -> TaskParitySnapshot {
    var board = TaskBoard.demo()
    let initial = board.rows
    let added = board.add(
        "  Preparar clase de LPS  ",
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!
    )
    let toggled = board.toggle(board.tasks[0].id)
    let deleted = board.delete(board.tasks[1].id)
    board.features = .basic
    return TaskParitySnapshot(
        initial: initial,
        after: board.rows,
        total: board.tasks.count,
        completed: board.completedCount,
        added: added,
        toggled: toggled,
        deleted: deleted
    )
}
