import SwiftUI

// Sesión 2: primera interfaz declarativa. El producto se presentará
// antes de pasar al modelo de tareas y al ViewModel.
struct ContentView: View {
    @State private var nombre = ""

    var body: some View {
        VStack(spacing: 18) {
            Text("TaskApp Pro")
                .font(.largeTitle.bold())

            Text("Una familia de aplicaciones para gestionar tareas")
                .foregroundStyle(.secondary)

            TextField("Introduce tu nombre", text: $nombre)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 360)

            Text(nombre.isEmpty ? "¡Hola, mundo!" : "¡Hola, \(nombre)!")
                .font(.title2)

            Button("Reiniciar saludo") {
                nombre = ""
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .frame(minWidth: 520, minHeight: 320)
    }
}

#Preview {
    ContentView()
}
