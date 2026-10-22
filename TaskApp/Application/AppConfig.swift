import SwiftUI

// Sesión 4: una única configuración observable de la variante del producto.
@MainActor
final class AppConfig: ObservableObject {
    @Published var showDueDates = true
    @Published var showPriorities = true
    // Puntos de extensión posteriores; aún no existe la funcionalidad.
    @Published var enableReminders = false
}
