import SwiftUI

@main
struct TaskApp: App {
    /// Una sola configuración para toda la app: la comparten Tareas y Ajustes.
    @State private var config = AppConfig()
    @State private var selection: String? = "tareas"

    var body: some Scene {
        WindowGroup {
#if os(iOS)
            TabView {
                TaskListView()
                    .tabItem { Label("Tareas", systemImage: "checklist") }
                SettingsView()
                    .tabItem { Label("Ajustes", systemImage: "gearshape") }
            }
            .environment(config)
#else
            NavigationSplitView {
                List(selection: $selection) {
                    NavigationLink(value: "tareas") {
                        Label("Tareas", systemImage: "checklist")
                    }
                    NavigationLink(value: "ajustes") {
                        Label("Ajustes", systemImage: "gearshape")
                    }
                }
            } detail: {
                switch selection {
                case "tareas":
                    TaskListView()
                case "ajustes":
                    SettingsView()
                default:
                    Text("Elige una opción")
                }
            }
            .environment(config)
#endif
        }
    }
}
