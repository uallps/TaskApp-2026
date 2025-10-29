//
//  AppConfig.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//

import Foundation

/// Gestor centralizado de configuración de la aplicación
/// Implementa el patrón Singleton para acceso global
class AppConfig {
    
    // MARK: - Singleton
    
    static let shared = AppConfig()
    
    private init() {
        // Inicialización privada para forzar el uso del singleton
    }
    
    // MARK: - Storage Configuration
    
    /// Tipo de almacenamiento activo
    enum StorageType {
        case json
        case swiftData
        case userDefaults
    }
    
    /// Almacenamiento actualmente configurado
    private(set) var activeStorageType: StorageType = .json
    
    /// Proveedor de almacenamiento activo
    private(set) lazy var storageProvider: StorageProvider = {
        createStorageProvider(for: activeStorageType)
    }()
    
    /// Crea un proveedor de almacenamiento según el tipo especificado
    /// - Parameter type: Tipo de almacenamiento deseado
    /// - Returns: Instancia de StorageProvider
    private func createStorageProvider(for type: StorageType) -> StorageProvider {
        switch type {
        case .json:
            return JSONStorageProvider()
        case .swiftData:
            if #available(iOS 17.0, *) {
                return SwiftDataStorageProvider()
            } else {
                print("⚠️ SwiftData requiere iOS 17+, usando JSON como fallback")
                return JSONStorageProvider()
            }
        case .userDefaults:
            // TODO: Implementar en futuras sesiones
            fatalError("UserDefaults storage no implementado aún")
        }
    }
    
    /// Cambia el tipo de almacenamiento activo
    /// - Parameter type: Nuevo tipo de almacenamiento
    /// - Note: Este cambio requerirá migración de datos en producción
    func setStorageType(_ type: StorageType) {
        activeStorageType = type
        storageProvider = createStorageProvider(for: type)
        print("🔄 Storage provider cambiado a: \(type)")
    }
    
    // MARK: - Feature Flags
    
    /// Habilita la funcionalidad de recordatorios
    static var enableReminders: Bool = true
    
    /// Habilita la funcionalidad de rachas
    static var enableStreaks: Bool = false
    
    /// Habilita estadísticas avanzadas
    static var enableAdvancedStats: Bool = false
    
    /// Habilita sincronización en la nube
    static var enableCloudSync: Bool = false
    
    /// Modo de depuración con logs detallados
    static var debugMode: Bool = true
    
    // Flags de UI existentes
    static var showDueDates: Bool = true
    static var showPriorities: Bool = true
    
    // MARK: - Storage Keys
    
    /// Claves utilizadas para almacenamiento persistente
    struct StorageKeys {
        static let tasks = "tasks"
        static let habits = "habits"
        static let streaks = "streaks"
        static let settings = "settings"
    }
    
    // MARK: - App Constants
    
    /// Constantes de la aplicación
    struct Constants {
        static let appName = "TaskApp"
        static let appVersion = "1.0.0"
        static let maxTasksPerList = 100
        static let defaultReminderTime: TimeInterval = 3600 // 1 hora antes
    }
}
