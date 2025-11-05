//
//  TaskAppApp.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//

import SwiftUI
import SwiftData

@main
struct TaskApp: App {
    @State private var selectedDetailView: String?

    let appConfig = AppConfig()

    var body: some Scene {
        WindowGroup{
            #if os(iOS) 
            TabView {
                TaskListView(appConfig: appConfig)
                    .tabItem {
                        Label("Tareas", systemImage: "checklist")
                    }
                SettingsView()
                    .tabItem {
                        Label("Ajustes", systemImage: "gearshape")
                    }
            }
            .environmentObject(appConfig)
            .modelContainer(for: [Task.self])
            #else
            NavigationSplitView {
                List(selection: $selectedDetailView) {
                    NavigationLink(value: "tareas") {
                        Label("Tareas", systemImage: "checklist")
                    }
                    NavigationLink(value: "ajustes") {
                        Label("Ajustes", systemImage: "gearshape")
                    }
                }
            } detail: {
                switch selectedDetailView {
                case "tareas":
                    TaskListView(appConfig: appConfig)
                case "ajustes":
                    SettingsView()
                default:
                    Text("Seleccione una opción")
                }
            }.environmentObject(appConfig)
            .modelContainer(for: [Task.self])
            #endif
        }
    }
}
