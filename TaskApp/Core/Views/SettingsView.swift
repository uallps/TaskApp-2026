//
//  SettingsView.swift
//  TaskApp
//
//  Created by Francisco José García García on 28/10/25.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: SettingsViewModel
    
    init(taskViewModel: TaskListViewModel) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(taskViewModel: taskViewModel))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Storage Section
                Section {
                    Picker("Storage Provider", selection: $viewModel.selectedStorageType) {
                        Text("JSON Files").tag(AppConfig.StorageType.json)
                        
                        if #available(iOS 17.0, *) {
                            Text("SwiftData").tag(AppConfig.StorageType.swiftData)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    if viewModel.isChangingStorage {
                        HStack {
                            ProgressView()
                            Text("Migrando datos...")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Text("Cambiar el storage provider migrará todas tus tareas")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                } header: {
                    Label("Almacenamiento", systemImage: "externaldrive")
                } footer: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("• **JSON**: Archivos legibles, fácil debug")
                        Text("• **SwiftData**: Búsquedas rápidas, queries avanzadas")
                    }
                    .font(.caption)
                }
                
                // MARK: - Feature Flags Section
                Section {
                    Toggle("Mostrar fechas límite", isOn: $viewModel.showDueDates)
                    Toggle("Mostrar prioridades", isOn: $viewModel.showPriorities)
                    Toggle("Habilitar recordatorios", isOn: $viewModel.enableReminders)
                    Toggle("Modo debug", isOn: $viewModel.debugMode)
                } header: {
                    Label("Características", systemImage: "slider.horizontal.3")
                }
                
                // MARK: - Storage Info Section
                Section {
                    LabeledContent("Storage activo") {
                        Text(viewModel.currentStorageType)
                            .foregroundStyle(.secondary)
                    }
                    
                    LabeledContent("Plugins disponibles") {
                        Text("\(viewModel.availablePlugins.count)")
                            .foregroundStyle(.secondary)
                    }
                    
                    LabeledContent("Total de tareas") {
                        Text("\(viewModel.taskCount)")
                            .foregroundStyle(.secondary)
                    }
                    
                } header: {
                    Label("Información", systemImage: "info.circle")
                }
                
                // MARK: - Debug Section
                if viewModel.debugMode {
                    Section {
                        Button("Ver ruta de archivos JSON") {
                            viewModel.showJSONPath()
                        }
                        
                        Button("Recargar tareas") {
                            viewModel.reloadTasks()
                        }
                        
                        Button("Crear tarea de prueba") {
                            viewModel.createTestTask()
                        }
                        
                    } header: {
                        Label("Opciones de Debug", systemImage: "ladybug")
                    }
                }
                
                // MARK: - Danger Zone
                Section {
                    Button(role: .destructive) {
                        viewModel.showDeleteConfirmation = true
                    } label: {
                        Label("Eliminar todas las tareas", systemImage: "trash")
                    }
                } header: {
                    Text("Zona de peligro")
                }
            }
            .navigationTitle("Configuración")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") {
                        dismiss()
                    }
                }
            }
            .alert("¿Eliminar todas las tareas?", isPresented: $viewModel.showDeleteConfirmation) {
                Button("Cancelar", role: .cancel) { }
                Button("Eliminar", role: .destructive) {
                    viewModel.deleteAllTasks()
                    dismiss()
                }
            } message: {
                Text("Esta acción no se puede deshacer")
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

// MARK: - SettingsViewModel

@MainActor
class SettingsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var selectedStorageType: AppConfig.StorageType {
        didSet {
            if selectedStorageType != oldValue {
                changeStorageProvider(to: selectedStorageType)
            }
        }
    }
    
    @Published var showDueDates = AppConfig.showDueDates {
        didSet { AppConfig.showDueDates = showDueDates }
    }
    
    @Published var showPriorities = AppConfig.showPriorities {
        didSet { AppConfig.showPriorities = showPriorities }
    }
    
    @Published var enableReminders = AppConfig.enableReminders {
        didSet { AppConfig.enableReminders = enableReminders }
    }
    
    @Published var debugMode = AppConfig.debugMode {
        didSet { AppConfig.debugMode = debugMode }
    }
    
    @Published var isChangingStorage = false
    @Published var showDeleteConfirmation = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    // MARK: - Private Properties
    
    private let taskViewModel: TaskListViewModel
    
    // MARK: - Computed Properties
    
    var currentStorageType: String {
        switch AppConfig.shared.activeStorageType {
        case .json: return "JSON"
        case .swiftData: return "SwiftData"
        case .userDefaults: return "UserDefaults"
        }
    }
    
    var availablePlugins: [String] {
        PluginRegistry.shared.availableStoragePlugins()
    }
    
    var taskCount: Int {
        taskViewModel.tasks.count
    }
    
    // MARK: - Initialization
    
    init(taskViewModel: TaskListViewModel) {
        self.taskViewModel = taskViewModel
        self.selectedStorageType = AppConfig.shared.activeStorageType
    }
    
    // MARK: - Methods
    
    func changeStorageProvider(to type: AppConfig.StorageType) {
        isChangingStorage = true
        
        Task {
            do {
                // Guardar las tareas actuales
                let currentTasks = taskViewModel.tasks
                
                // Cambiar el storage provider
                AppConfig.shared.setStorageType(type)
                
                // Crear un nuevo ViewModel con el nuevo provider
                let newProvider = AppConfig.shared.storageProvider
                
                // Migrar los datos
                try newProvider.save(currentTasks, forKey: AppConfig.StorageKeys.tasks)
                
                // Recargar las tareas en el ViewModel actual
                taskViewModel.loadTasks()
                
                print("✅ Storage migrado exitosamente a: \(type)")
                
                await MainActor.run {
                    isChangingStorage = false
                }
            } catch {
                await MainActor.run {
                    isChangingStorage = false
                    errorMessage = "Error al migrar datos: \(error.localizedDescription)"
                    showError = true
                    
                    // Revertir el cambio
                    selectedStorageType = AppConfig.shared.activeStorageType
                }
            }
        }
    }
    
    func showJSONPath() {
        if let jsonProvider = AppConfig.shared.storageProvider as? JSONStorageProvider {
            let path = jsonProvider.getFilePath(forKey: AppConfig.StorageKeys.tasks)
            print("📁 JSON Path: \(path)")
            
            // Copiar al clipboard
            #if os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(path, forType: .string)
            #endif
        }
    }
    
    func reloadTasks() {
        taskViewModel.loadTasks()
        print("🔄 Tareas recargadas")
    }
    
    func createTestTask() {
        let testTask = Task(
            title: "Tarea de prueba \(Date().formatted())",
            priority: .medium
        )
        taskViewModel.addTask(task: testTask)
        print("✅ Tarea de prueba creada")
    }
    
    func deleteAllTasks() {
        taskViewModel.deleteAllTasks()
        print("🗑️ Todas las tareas eliminadas")
    }
}

#Preview {
    SettingsView(taskViewModel: TaskListViewModel())
}
