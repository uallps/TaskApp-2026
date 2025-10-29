//
//  PluginRegistry.swift
//  TaskApp
//
//  Created by Francisco José García García on 28/10/25.
//

import Foundation

/// Registro centralizado de plugins de la aplicación
/// Este componente gestiona todos los plugins activos y permite su activación/desactivación dinámica
class PluginRegistry {
    
    // MARK: - Singleton
    
    static let shared = PluginRegistry()
    
    private init() {
        // Inicialización privada
    }
    
    // MARK: - Storage Plugins
    
    /// Plugins de almacenamiento disponibles
    private var storagePlugins: [String: StorageProvider] = [:]
    
    /// Registra un plugin de almacenamiento
    /// - Parameters:
    ///   - plugin: Instancia del plugin
    ///   - name: Nombre identificador del plugin
    func registerStoragePlugin(_ plugin: StorageProvider, name: String) {
        storagePlugins[name] = plugin
        print("🔌 Storage plugin registrado: \(name)")
    }
    
    /// Obtiene un plugin de almacenamiento por nombre
    /// - Parameter name: Nombre del plugin
    /// - Returns: Plugin si existe, nil en caso contrario
    func getStoragePlugin(named name: String) -> StorageProvider? {
        return storagePlugins[name]
    }
    
    /// Lista todos los plugins de almacenamiento disponibles
    /// - Returns: Array de nombres de plugins
    func availableStoragePlugins() -> [String] {
        return Array(storagePlugins.keys)
    }
    
    // MARK: - Setup
    
    /// Configura los plugins por defecto de la aplicación
    func setupDefaultPlugins() {
        // Registrar el plugin JSON
        registerStoragePlugin(JSONStorageProvider(), name: "JSON")
        
        // Registrar el plugin SwiftData (iOS 17+)
        if #available(iOS 17.0, *) {
            registerStoragePlugin(SwiftDataStorageProvider(), name: "SwiftData")
        }
        
        print("✅ Plugins por defecto configurados")
    }
}
