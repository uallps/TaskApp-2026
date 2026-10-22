import Foundation

// Sesión 1: práctica de Swift sin structs, SwiftUI ni persistencia.
// Cada tarea es un diccionario: las fechas se guardan como Date.
typealias RegistroTarea = [String: Any]

@discardableResult
func anadir(
    id: String,
    titulo: String,
    fechaAlta: Date,
    en tareas: inout [String: RegistroTarea]
) -> Bool {
    let tituloLimpio = titulo.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !id.isEmpty, !tituloLimpio.isEmpty, tareas[id] == nil else { return false }
    tareas[id] = [
        "titulo": tituloLimpio,
        "fechaAlta": fechaAlta,
        "fechaFin": NSNull(),
        "completada": false
    ]
    return true
}

@discardableResult
func completar(
    id: String,
    fechaFin: Date,
    en tareas: inout [String: RegistroTarea]
) -> Bool {
    guard var tarea = tareas[id],
          let fechaAlta = tarea["fechaAlta"] as? Date,
          fechaFin >= fechaAlta else { return false }
    tarea["completada"] = true
    tarea["fechaFin"] = fechaFin
    tareas[id] = tarea
    return true
}

@discardableResult
func eliminar(id: String, de tareas: inout [String: RegistroTarea]) -> Bool {
    tareas.removeValue(forKey: id) != nil
}

func porcentajeCompletadas(_ tareas: [String: RegistroTarea]) -> Double {
    guard !tareas.isEmpty else { return 0 }
    let completadas = tareas.values.filter { ($0["completada"] as? Bool) == true }.count
    return 100.0 * Double(completadas) / Double(tareas.count)
}

func duracionesDeTareasCompletadas(
    _ tareas: [String: RegistroTarea]
) -> [(id: String, segundos: TimeInterval)] {
    tareas.compactMap { id, tarea in
        guard (tarea["completada"] as? Bool) == true,
              let inicio = tarea["fechaAlta"] as? Date,
              let fin = tarea["fechaFin"] as? Date else { return nil }
        return (id: id, segundos: fin.timeIntervalSince(inicio))
    }
    .sorted {
        if $0.segundos == $1.segundos { return $0.id < $1.id }
        return $0.segundos > $1.segundos
    }
}

func listar(_ tareas: [String: RegistroTarea]) {
    for id in tareas.keys.sorted() {
        guard let tarea = tareas[id] else { continue }
        let titulo = tarea["titulo"] as? String ?? "(sin título)"
        let completada = tarea["completada"] as? Bool ?? false
        print("\(id): \(titulo) — \(completada ? "completada" : "pendiente")")
    }
}

// Demostración y comprobaciones reproducibles de la práctica.
var tareas: [String: RegistroTarea] = [:]
assert(porcentajeCompletadas(tareas) == 0)
assert(!eliminar(id: "inexistente", de: &tareas))

let inicio = Date(timeIntervalSince1970: 1_700_000_000)
assert(anadir(id: "T1", titulo: "Preparar clase", fechaAlta: inicio, en: &tareas))
assert(anadir(id: "T2", titulo: "Revisar prácticas", fechaAlta: inicio, en: &tareas))
assert(!anadir(id: "T2", titulo: "Duplicada", fechaAlta: inicio, en: &tareas))
assert(completar(id: "T1", fechaFin: inicio.addingTimeInterval(3_600), en: &tareas))
assert(porcentajeCompletadas(tareas) == 50)
assert(duracionesDeTareasCompletadas(tareas).first?.segundos == 3_600)

listar(tareas)
print("Completadas: \(Int(porcentajeCompletadas(tareas))) %")
assert(eliminar(id: "T2", de: &tareas))
assert(porcentajeCompletadas(tareas) == 100)
print("Comprobaciones de la sesión 1: OK")
