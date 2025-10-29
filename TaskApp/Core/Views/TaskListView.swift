//
//  TaskListView.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//
import Foundation
import SwiftUI

struct TaskListView: View {
    @StateObject var viewModel = TaskListViewModel()
    @State private var showingSettings = false

    var body: some View {
        VStack{
            NavigationStack{
                List {
                    ForEach($viewModel.tasks) { $task in
                        NavigationLink(destination: TaskDetailView(task: $task)){
                            TaskRowView(task: task, toggleCompletion: {
                                viewModel.toggleCompletion(task:task)
                            }).contextMenu {
                                Button("Eliminar Tarea") {
                                    if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                        viewModel.removeTasks(atOffsets: IndexSet(integer: index))
                                    }
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.removeTasks(atOffsets: indexSet)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Añadir Tarea") {
                            let newTask = Task(title:"Nueva Tarea")
                            viewModel.addTask(task:newTask)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showingSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
                .navigationTitle("Tareas")
                .sheet(isPresented: $showingSettings) {
                    SettingsView(taskViewModel: viewModel)
                }
            }
        }
    }
}

#Preview {
    TaskListView()
}