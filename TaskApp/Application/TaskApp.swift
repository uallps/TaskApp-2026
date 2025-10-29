//
//  TaskAppApp.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//

import SwiftUI

@main
struct TaskApp: App {
    
    init() {
        // Configurar el sistema de plugins al iniciar la app
        setupPlugins()
    }
    
    var body: some Scene {
        WindowGroup {
            TaskListView()
        }
    }
    
    // MARK: - Setup
    
    /// Configura el sistema de plugins y la arquitectura de persistencia
    private func setupPlugins() {
        // Registrar todos los plugins disponibles
        PluginRegistry.shared.setupDefaultPlugins()
        
        if AppConfig.debugMode {
            print("🚀 TaskApp iniciada")
            print("📦 Storage activo: \(AppConfig.shared.activeStorageType)")
            print("🔌 Plugins disponibles: \(PluginRegistry.shared.availableStoragePlugins())")
        }
    }
}
