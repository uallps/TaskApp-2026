import Foundation
import SwiftData

class SwiftDataStorageProvider: StorageProvider {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    init() throws {
        self.modelContainer = try ModelContainer(for: Task.self)
        self.modelContext = ModelContext(modelContainer)
    }
    
    func loadTasks() async throws -> [Task] {
        let descriptor = FetchDescriptor<Task>()
        return try modelContext.fetch(descriptor)
    }
    
    func saveTasks(tasks: [Task]) async throws {
        // Delete existing tasks
        try modelContext.delete(model: Task.self)
        // Insert new tasks
        for task in tasks {
            modelContext.insert(task)
        }
        try modelContext.save()
    }
}