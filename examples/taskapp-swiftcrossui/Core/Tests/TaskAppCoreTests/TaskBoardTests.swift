import Foundation
import XCTest
@testable import TaskAppCore

final class TaskBoardTests: XCTestCase {
    func testDemoTasksAndCompletion() {
        var board = TaskBoard.demo()
        XCTAssertEqual(board.tasks.count, 3)
        XCTAssertEqual(board.completedCount, 0)

        let first = board.tasks[0].id
        XCTAssertTrue(board.toggle(first))
        XCTAssertTrue(board.tasks[0].isCompleted)
        XCTAssertEqual(board.completedCount, 1)
        XCTAssertEqual(board.rows[0].status, "Completada")
        XCTAssertTrue(board.toggle(first))
        XCTAssertFalse(board.tasks[0].isCompleted)
    }

    func testAddTrimsWhitespaceAndRejectsEmptyTitles() {
        var board = TaskBoard()
        XCTAssertFalse(board.add(" \n "))
        XCTAssertTrue(board.tasks.isEmpty)
        XCTAssertTrue(board.add("  Leer un libro  "))
        XCTAssertEqual(board.tasks[0].title, "Leer un libro")
    }

    func testDeleteAndUnknownIdentifiers() {
        var board = TaskBoard.demo()
        XCTAssertFalse(board.toggle(UUID()))
        XCTAssertFalse(board.delete(UUID()))
        XCTAssertTrue(board.delete(board.tasks[1].id))
        XCTAssertEqual(board.tasks.map(\.title), ["Comprar leche", "Llamar a mamá"])
    }

    func testFeaturesDoNotDeleteCoreData() {
        var board = TaskBoard.demo()
        XCTAssertEqual(board.rows[0].dueDate, "2026-11-15")
        XCTAssertEqual(board.rows[0].priority, "Alta")
        board.features = .basic
        XCTAssertNil(board.rows[0].dueDate)
        XCTAssertNil(board.rows[0].priority)
        XCTAssertEqual(board.tasks.count, 3)
        XCTAssertNotNil(board.tasks[0].dueDate)
        XCTAssertEqual(board.tasks[0].priority, .high)
    }

    func testParityScenarioIsStable() {
        let report = runTaskParityScenario()
        XCTAssertTrue(report.added)
        XCTAssertTrue(report.toggled)
        XCTAssertTrue(report.deleted)
        XCTAssertEqual(report.total, 3)
        XCTAssertEqual(report.completed, 1)
        XCTAssertEqual(report.initial.map(\.title), ["Comprar leche", "Hacer ejercicio", "Llamar a mamá"])
        XCTAssertEqual(report.after.map(\.title), ["Comprar leche", "Llamar a mamá", "Preparar clase de LPS"])
        XCTAssertTrue(report.after[0].isCompleted)
        XCTAssertNil(report.after[0].dueDate)
    }
}
