# Capa de Persistencia Abstracta - TaskApp

## 📋 Sesión 7: Implementación

### Objetivos Completados ✅

1. ✅ Diseñar una capa de persistencia abstracta usando un protocolo
2. ✅ Implementar el primer "plugin" de persistencia usando Codable y JSON
3. ✅ Desacoplar la lógica de la interfaz de la implementación de persistencia

---

## 🏗️ Arquitectura Implementada

### Principio de Inversión de Dependencias (DIP)

La arquitectura sigue el **Principio de Inversión de Dependencias** del SOLID:

```
┌─────────────────────────────────────┐
│   TaskListViewModel (Capa Alta)    │
│                                     │
│   Depende de → StorageProvider     │ ← ABSTRACCIÓN (Protocolo)
└─────────────────────────────────────┘
                ▲
                │ implementa
                │
┌───────────────┴──────────────────┐
│                                  │
│  JSONStorageProvider             │
│  (Plugin 1 - Implementación)     │ ← DETALLE (Clase Concreta)
└──────────────────────────────────┘
```

**Ventajas:**
- ✨ El ViewModel NO conoce los detalles de implementación
- 🔄 Podemos cambiar de JSON a SwiftData sin modificar el ViewModel
- 🧪 Facilita los tests con mocks del StorageProvider
- 📦 Sistema extensible: agregar nuevos plugins es trivial

---

## 📁 Estructura de Archivos

```
TaskApp/
├── 📂 Application/
│   ├── TaskApp.swift          # Punto de entrada (@main)
│   └── AppConfig.swift         # Gestor de feature flags y configuración
│
├── 📂 Core/
│   ├── 📂 Models/
│   │   └── Task.swift          # Modelo Codable
│   ├── 📂 Views/
│   │   ├── TaskListView.swift
│   │   ├── TaskRowView.swift
│   │   └── TaskDetailView.swift
│   └── 📂 ViewModels/
│       └── TaskListViewModel.swift  # Usa StorageProvider (abstracción)
│
└── 📂 Infrastructure/          # ← NUEVA CAPA
    ├── 📂 Persistence/
    │   ├── StorageProvider.swift         # Protocolo (contrato)
    │   └── JSONStorageProvider.swift     # Plugin 1: Implementación JSON
    └── 📂 Plugins/
        └── PluginRegistry.swift          # Registro de plugins
```

---

## 🔌 Plugin 1: JSONStorageProvider

### Características

- **Almacenamiento**: Sistema de archivos local usando `FileManager`
- **Formato**: JSON legible (pretty-printed)
- **Ubicación**: `~/Documents/TaskAppData/`
- **Codificación**: ISO 8601 para fechas
- **Protección**: Archivos con protección completa

### Ejemplo de archivo generado

**Ubicación:** `~/Documents/TaskAppData/tasks.json`

```json
[
  {
    "dueDate": "2025-10-29T12:00:00Z",
    "id": "A1B2C3D4-E5F6-7890-ABCD-EF1234567890",
    "isCompleted": false,
    "priority": "low",
    "title": "Comprar leche"
  },
  {
    "id": "B2C3D4E5-F6A7-8901-BCDE-F12345678901",
    "isCompleted": false,
    "priority": "high",
    "title": "Hacer ejercicio"
  }
]
```

---

## 💡 Protocolo StorageProvider

### Métodos del Contrato

```swift
protocol StorageProvider {
    // Guardar datos
    func save<T: Codable>(_ items: [T], forKey key: String) throws
    
    // Cargar datos
    func load<T: Codable>(forKey key: String) throws -> [T]
    
    // Eliminar datos
    func delete(forKey key: String) throws
    
    // Verificar existencia
    func exists(forKey key: String) -> Bool
}
```

### Manejo de Errores

```swift
enum StorageError: LocalizedError {
    case encodingFailed(Error)
    case decodingFailed(Error)
    case fileNotFound
    case saveFailed(Error)
    case deleteFailed(Error)
    case invalidData
}
```

---

## 🎯 AppConfig: Gestión Centralizada

### Feature Flags

```swift
class AppConfig {
    static let shared = AppConfig()
    
    // Storage activo
    var storageProvider: StorageProvider
    
    // Feature flags
    static var enableReminders: Bool = true
    static var enableStreaks: Bool = false
    static var debugMode: Bool = true
    
    // Storage keys
    struct StorageKeys {
        static let tasks = "tasks"
        static let habits = "habits"
    }
}
```

### Cambiar Storage Provider

```swift
// Cambiar de JSON a otro storage
AppConfig.shared.setStorageType(.swiftData)
```

---

## 🔄 Flujo de Datos

### 1. Guardar Tarea

```
Usuario añade tarea
      ↓
TaskListView.addTask()
      ↓
TaskListViewModel.addTask()
      ↓
tasks.append(task)
      ↓
saveTasks()
      ↓
storageProvider.save(tasks, forKey: "tasks")
      ↓
JSONStorageProvider codifica a JSON
      ↓
Escribe archivo: ~/Documents/TaskAppData/tasks.json
```

### 2. Cargar Tareas

```
App inicia
      ↓
TaskListViewModel.init()
      ↓
loadTasks()
      ↓
storageProvider.load(forKey: "tasks")
      ↓
JSONStorageProvider lee archivo
      ↓
Decodifica JSON a [Task]
      ↓
@Published tasks actualizado
      ↓
SwiftUI re-renderiza la vista
```

---

## 🧪 Ventajas de Testing

### Mock del StorageProvider

```swift
class MockStorageProvider: StorageProvider {
    var savedData: [String: Any] = [:]
    
    func save<T: Codable>(_ items: [T], forKey key: String) throws {
        savedData[key] = items
    }
    
    func load<T: Codable>(forKey key: String) throws -> [T] {
        return savedData[key] as? [T] ?? []
    }
    
    // ... otros métodos
}

// En tests
let viewModel = TaskListViewModel(
    storageProvider: MockStorageProvider()
)
```

---

## 🚀 Próximos Pasos (Futuras Sesiones)

### Plugin 2: SwiftData
- Persistencia usando el framework moderno de Apple
- Soporte para consultas complejas
- Sincronización con iCloud

### Plugin 3: CloudKit
- Sincronización multi-dispositivo
- Backup automático en iCloud

### Migración de Datos
- Sistema para migrar entre diferentes storage providers
- Exportar/importar datos

---

## 📝 Conceptos Clave Aprendidos

1. **Inversión de Dependencias**: Las capas altas no deben depender de detalles de implementación
2. **Protocolos como Contratos**: Definen el "qué" sin especificar el "cómo"
3. **Plugin Architecture**: Sistema modular y extensible
4. **Inyección de Dependencias**: El ViewModel recibe el StorageProvider, no lo crea
5. **Codable Protocol**: Serialización/deserialización automática en Swift

---

## 🎓 Ejercicios Propuestos

1. **Añadir logging**: Crear un `LoggingStorageProvider` que envuelva otro provider y registre todas las operaciones
2. **Implementar caché**: Crear un provider que cachee en memoria y sincronice con disco
3. **Añadir encriptación**: Crear un provider que encripte los JSON antes de guardarlos
4. **Implementar búsqueda**: Añadir método `search(query: String)` al protocolo

---

## 📚 Referencias

- [Swift Protocols](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/)
- [Codable in Swift](https://developer.apple.com/documentation/swift/codable)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
- [Dependency Inversion Principle](https://en.wikipedia.org/wiki/Dependency_inversion_principle)
