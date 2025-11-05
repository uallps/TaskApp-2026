//
//  TaskListView.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//
import Foundation
import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var appConfig: AppConfig
    @StateObject private var viewModel: TaskListViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: TaskListViewModel(appConfig: AppConfig()))
    }
    
    var body: some View {
        VStack{
            NavigationStack{
                List {
                    ForEach($viewModel.tasks) { $task in
                        taskRow(task: task)
                    }
                    .onDelete { indexSet in
                        _Concurrency.Task {
                            await viewModel.removeTasks(atOffsets: indexSet)
                        }
                    }
                }
                .toolbar {
                    Button("Añadir Tarea") {
                        addNewTask()
                    }
                }
                .navigationTitle("Tareas")
                .task {
                    await viewModel.loadTasks()
                }
            }
        }
    }
    
    @ViewBuilder
    private func taskRow(task: Task) -> some View {
        NavigationLink(destination: TaskDetailView(
            task: binding(for: task),
            onSave: {
                saveTasks()
            }
        )) {
            TaskRowView(task: task, toggleCompletion: {
                _Concurrency.Task {
                    await viewModel.toggleCompletion(task: task)
                }
            })
            .contextMenu {
                Button("Eliminar Tarea") {
                    deleteTask(task)
                }
            }
        }
    }
    
    private func binding(for task: Task) -> Binding<Task> {
        guard let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) else {
            fatalError("Task not found")
        }
        return $viewModel.tasks[index]
    }
    
    private func deleteTask(_ task: Task) {
        if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
            _Concurrency.Task {
                await viewModel.removeTasks(atOffsets: IndexSet(integer: index))
            }
        }
    }
    
    private func addNewTask() {
        let newTask = Task(title: "Nueva Tarea")
        _Concurrency.Task {
            await viewModel.addTask(task: newTask)
        }
    }
    
    private func saveTasks() {
        _Concurrency.Task {
            await viewModel.saveTasks()
        }
    }
}

#Preview {
    TaskListView(storageProvider: MockStorageProvider())
}

