//
//  TaskListViewModel.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//
import Foundation
import Combine
import SwiftUI

/// ViewModel para la lista de tareas
/// Ahora DESACOPLADO de la implementación de persistencia gracias al protocolo StorageProvider
class TaskListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var tasks: [Task] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    // MARK: - Private Properties
    
    /// Proveedor de almacenamiento (puede ser JSON, SwiftData, etc.)
    /// ✨ Inversión de Dependencias: dependemos de la ABSTRACCIÓN (protocolo)
    /// no de la IMPLEMENTACIÓN concreta
    private let storageProvider: StorageProvider
    
    /// Clave para almacenar las tareas
    private let storageKey = AppConfig.StorageKeys.tasks
    
    // MARK: - Initialization
    
    /// Inicializador con inyección de dependencias
    /// - Parameter storageProvider: Proveedor de almacenamiento a utilizar
    init(storageProvider: StorageProvider = AppConfig.shared.storageProvider) {
        self.storageProvider = storageProvider
        loadTasks()
    }
    
    // MARK: - Public Methods
    
    /// Añade una nueva tarea
    /// - Parameter task: Tarea a añadir
    func addTask(task: Task) {
        tasks.append(task)
        saveTasks()
    }
    
    /// Elimina tareas en las posiciones especificadas
    /// - Parameter offsets: Índices de las tareas a eliminar
    func removeTasks(atOffsets offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }
    
    /// Alterna el estado de completado de una tarea
    /// - Parameter task: Tarea a modificar
    func toggleCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }
    
    /// Actualiza una tarea existente
    /// - Parameter task: Tarea con los datos actualizados
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
        }
    }
    
    /// Elimina todas las tareas completadas
    func clearCompletedTasks() {
        tasks.removeAll { $0.isCompleted }
        saveTasks()
    }
    
    // MARK: - Persistence Methods
    
    /// Carga las tareas desde el almacenamiento
    func loadTasks() {
        isLoading = true
        errorMessage = nil
        
        do {
            tasks = try storageProvider.load(forKey: storageKey)
            
            if AppConfig.debugMode {
                print("📱 Tareas cargadas: \(tasks.count)")
            }
            
            // Si no hay tareas, crear algunas de ejemplo
            if tasks.isEmpty {
                loadSampleTasks()
            }
        } catch {
            errorMessage = "Error al cargar tareas: \(error.localizedDescription)"
            print("❌ \(errorMessage ?? "")")
            
            // En caso de error, cargar tareas de ejemplo
            loadSampleTasks()
        }
        
        isLoading = false
    }
    
    /// Guarda las tareas en el almacenamiento
    private func saveTasks() {
        do {
            try storageProvider.save(tasks, forKey: storageKey)
            
            if AppConfig.debugMode {
                print("💾 Tareas guardadas: \(tasks.count)")
            }
            
            errorMessage = nil
        } catch {
            errorMessage = "Error al guardar tareas: \(error.localizedDescription)"
            print("❌ \(errorMessage ?? "")")
        }
    }
    
    /// Carga tareas de ejemplo para demostración
    private func loadSampleTasks() {
        tasks = [
            Task(
                title: "Comprar leche",
                dueDate: Date().addingTimeInterval(86400),
                priority: .low
            ),
            Task(
                title: "Hacer ejercicio",
                isCompleted: false,
                priority: .high
            ),
            Task(
                title: "Llamar a mamá",
                priority: .medium
            ),
            Task(
                title: "Revisar email",
                isCompleted: true,
                dueDate: Date()
            )
        ]
        
        // Guardar las tareas de ejemplo
        saveTasks()
    }
    
    /// Elimina todas las tareas y el archivo de almacenamiento
    func deleteAllTasks() {
        do {
            try storageProvider.delete(forKey: storageKey)
            tasks.removeAll()
            errorMessage = nil
            
            if AppConfig.debugMode {
                print("🗑️ Todas las tareas eliminadas")
            }
        } catch {
            errorMessage = "Error al eliminar tareas: \(error.localizedDescription)"
            print("❌ \(errorMessage ?? "")")
        }
    }
    
    // MARK: - Computed Properties
    
    /// Tareas pendientes
    var pendingTasks: [Task] {
        tasks.filter { !$0.isCompleted }
    }
    
    /// Tareas completadas
    var completedTasks: [Task] {
        tasks.filter { $0.isCompleted }
    }
    
    /// Progreso de completado (0.0 a 1.0)
    var completionProgress: Double {
        guard !tasks.isEmpty else { return 0.0 }
        return Double(completedTasks.count) / Double(tasks.count)
    }
}
