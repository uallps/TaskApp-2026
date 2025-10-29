//
//  SwiftDataStorageProvider.swift
//  TaskApp
//
//  Created by Francisco José García García on 28/10/25.
//

import Foundation
import SwiftData

/// Plugin 2: Implementación de persistencia usando SwiftData
/// SwiftData es el framework moderno de Apple que reemplaza CoreData
@available(iOS 17.0, *)
class SwiftDataStorageProvider: StorageProvider {
    
    // MARK: - Properties
    
    /// Contenedor del modelo de SwiftData
    private let modelContainer: ModelContainer
    
    /// Contexto principal para operaciones de SwiftData
    private var mainContext: ModelContext {
        modelContainer.mainContext
    }
    
    // MARK: - Initialization
    
    /// Inicializa el proveedor de almacenamiento SwiftData
    /// - Parameter modelTypes: Tipos de modelos a gestionar (por defecto: Task)
    init(modelTypes: [any PersistentModel.Type] = [TaskModel.self]) {
        do {
            // Crear el esquema con los modelos
            let schema = Schema(modelTypes)
            
            // Configurar el contenedor con almacenamiento persistente
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .none // Sin iCloud por ahora
            )
            
            // Crear el contenedor
            self.modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            
            print("✅ SwiftData container inicializado correctamente")
        } catch {
            fatalError("❌ Error al inicializar SwiftData: \(error.localizedDescription)")
        }
    }
    
    /// Inicializador para testing con almacenamiento en memoria
    /// - Parameter inMemory: Si es true, usa almacenamiento en memoria
    init(inMemory: Bool) {
        do {
            let schema = Schema([TaskModel.self])
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: inMemory
            )
            self.modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            print("✅ SwiftData container (in-memory: \(inMemory)) inicializado")
        } catch {
            fatalError("❌ Error al inicializar SwiftData: \(error.localizedDescription)")
        }
    }
    
    // MARK: - StorageProvider Protocol Implementation
    
    func save<T: Codable>(_ items: [T], forKey key: String) throws {
        guard T.self == Task.self else {
            throw StorageError.invalidData
        }
        
        let tasks = items as! [Task]
        
        do {
            // Eliminar todos los modelos existentes
            try deleteAllModels()
            
            // Insertar los nuevos modelos
            for task in tasks {
                let taskModel = TaskModel(from: task)
                mainContext.insert(taskModel)
            }
            
            // Guardar el contexto
            try mainContext.save()
            
            print("✅ SwiftData: \(items.count) tareas guardadas")
        } catch {
            throw StorageError.saveFailed(error)
        }
    }
    
    func load<T: Codable>(forKey key: String) throws -> [T] {
        guard T.self == Task.self else {
            throw StorageError.invalidData
        }
        
        do {
            // Crear descriptor de fetch
            let descriptor = FetchDescriptor<TaskModel>()
            
            // Ejecutar la consulta
            let taskModels = try mainContext.fetch(descriptor)
            
            // Convertir TaskModel -> Task
            let tasks = taskModels.map { $0.toTask() }
            
            print("✅ SwiftData: \(tasks.count) tareas cargadas")
            
            return tasks as! [T]
        } catch {
            throw StorageError.decodingFailed(error)
        }
    }
    
    func delete(forKey key: String) throws {
        do {
            try deleteAllModels()
            try mainContext.save()
            print("✅ SwiftData: Todas las tareas eliminadas")
        } catch {
            throw StorageError.deleteFailed(error)
        }
    }
    
    func exists(forKey key: String) -> Bool {
        do {
            let descriptor = FetchDescriptor<TaskModel>()
            let count = try mainContext.fetchCount(descriptor)
            return count > 0
        } catch {
            return false
        }
    }
    
    // MARK: - Private Helper Methods
    
    /// Elimina todos los modelos TaskModel del contexto
    private func deleteAllModels() throws {
        let descriptor = FetchDescriptor<TaskModel>()
        let models = try mainContext.fetch(descriptor)
        
        for model in models {
            mainContext.delete(model)
        }
    }
    
    // MARK: - SwiftData Specific Methods
    
    /// Obtiene el ModelContainer para uso en SwiftUI
    /// - Returns: ModelContainer configurado
    func getModelContainer() -> ModelContainer {
        return modelContainer
    }
    
    /// Busca tareas por título
    /// - Parameter searchText: Texto a buscar
    /// - Returns: Array de tareas que coinciden
    func searchTasks(searchText: String) throws -> [Task] {
        let predicate = #Predicate<TaskModel> { task in
            task.title.localizedStandardContains(searchText)
        }
        
        let descriptor = FetchDescriptor<TaskModel>(predicate: predicate)
        let taskModels = try mainContext.fetch(descriptor)
        
        return taskModels.map { $0.toTask() }
    }
    
    /// Filtra tareas por estado de completado
    /// - Parameter isCompleted: Estado a filtrar
    /// - Returns: Array de tareas filtradas
    func filterTasks(isCompleted: Bool) throws -> [Task] {
        let predicate = #Predicate<TaskModel> { task in
            task.isCompleted == isCompleted
        }
        
        let descriptor = FetchDescriptor<TaskModel>(predicate: predicate)
        let taskModels = try mainContext.fetch(descriptor)
        
        return taskModels.map { $0.toTask() }
    }
    
    /// Filtra tareas por prioridad
    /// - Parameter priority: Prioridad a filtrar
    /// - Returns: Array de tareas filtradas
    func filterTasks(priority: Priority) throws -> [Task] {
        let priorityRaw = priority.rawValue
        let predicate = #Predicate<TaskModel> { task in
            task.priorityRaw == priorityRaw
        }
        
        let descriptor = FetchDescriptor<TaskModel>(predicate: predicate)
        let taskModels = try mainContext.fetch(descriptor)
        
        return taskModels.map { $0.toTask() }
    }
}

// MARK: - TaskModel (SwiftData Model)

/// Modelo de SwiftData para Task
/// SwiftData requiere clases (no structs) con el macro @Model
@available(iOS 17.0, *)
@Model
final class TaskModel {
    
    // MARK: - Properties
    
    /// Identificador único
    @Attribute(.unique) var id: UUID
    
    /// Título de la tarea
    var title: String
    
    /// Estado de completado
    var isCompleted: Bool
    
    /// Fecha límite
    var dueDate: Date?
    
    /// Prioridad (almacenada como String)
    var priorityRaw: String?
    
    /// Fecha de recordatorio
    var reminderDate: Date?
    
    /// Fecha de creación
    var createdAt: Date
    
    // MARK: - Computed Properties
    
    /// Prioridad como enum
    var priority: Priority? {
        get {
            guard let raw = priorityRaw else { return nil }
            return Priority(rawValue: raw)
        }
        set {
            priorityRaw = newValue?.rawValue
        }
    }
    
    // MARK: - Initialization
    
    /// Inicializador completo
    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        dueDate: Date? = nil,
        priority: Priority? = nil,
        reminderDate: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.priorityRaw = priority?.rawValue
        self.reminderDate = reminderDate
        self.createdAt = createdAt
    }
    
    /// Crea un TaskModel desde un Task
    convenience init(from task: Task) {
        self.init(
            id: task.id,
            title: task.title,
            isCompleted: task.isCompleted,
            dueDate: task.dueDate,
            priority: task.priority,
            reminderDate: task.reminderDate
        )
    }
    
    // MARK: - Conversion Methods
    
    /// Convierte TaskModel a Task
    func toTask() -> Task {
        return Task(
            id: id,
            title: title,
            isCompleted: isCompleted,
            dueDate: dueDate,
            priority: priority,
            reminderDate: reminderDate
        )
    }
}
