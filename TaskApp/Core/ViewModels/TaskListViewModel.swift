//
//  TaskListViewModel.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//
import Foundation
import Combine
import SwiftUI

@MainActor
class TaskListViewModel: ObservableObject {
    
    private let storageProvider: StorageProvider
    
    init(appConfig: AppConfig) {
        switch appConfig.storageType {
        case .swiftdata:
            do {
                self.storageProvider = try SwiftDataStorageProvider()
            } catch {
                print("Error initializing SwiftDataStorageProvider: \(error)")
                // Fallback to JSON
                self.storageProvider = JSONStorageProvider()
            }
        case .json:
            self.storageProvider = JSONStorageProvider()
        }
    }
    
    @Published var tasks: [Task] = [
        Task(title: "Comprar leche", dueDate: Date().addingTimeInterval(86400)),
        Task(title: "Hacer ejercicio", priority: .high),
        Task(title: "Llamar a mamá")
    ]
    
    func loadTasks() async {
        do {
            tasks = try await storageProvider.loadTasks()
        } catch {
            print("Error loading tasks: \(error)")
        }
    }
    
    func addTask(task: Task) async{
        tasks.append(task)
        try? await storageProvider.saveTasks(tasks: tasks)
    }
    
    func removeTasks(atOffsets offsets: IndexSet) async{
        tasks.remove(atOffsets: offsets)
        try? await storageProvider.saveTasks(tasks: tasks)
    }
    
    func toggleCompletion(task: Task) async {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            try? await storageProvider.saveTasks(tasks: tasks)
        }
    }
    
    func saveTasks() async {
        try? await storageProvider.saveTasks(tasks: tasks)
    }
}
