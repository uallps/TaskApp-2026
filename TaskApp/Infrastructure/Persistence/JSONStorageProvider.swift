import Foundation

/// Guarda las tareas en un fichero JSON en la carpeta Documentos del usuario.
final class JSONStorageProvider: StorageProvider {
    private let fileURL: URL

    init(filename: String = "tasks.json") {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documents.appendingPathComponent(filename)
    }

    func loadTasks() async throws -> [Task] {
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([Task].self, from: data)
    }

    func saveTasks(tasks: [Task]) async throws {
        let data = try JSONEncoder().encode(tasks)
        // La carpeta Documentos no existe en todos los sistemas (por ejemplo, un Linux mínimo).
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: fileURL)
    }
}
