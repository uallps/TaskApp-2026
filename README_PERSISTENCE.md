# TaskApp - Guía de Uso del Sistema de Persistencia

## 🎯 Sesión 7: Capa de Persistencia Abstracta

### ✅ Implementación Completada

Se ha implementado exitosamente:

1. **Protocolo StorageProvider** - Define el contrato para cualquier sistema de persistencia
2. **JSONStorageProvider** - Primer plugin usando Codable y FileManager
3. **AppConfig** - Gestor centralizado de configuración y feature flags
4. **PluginRegistry** - Sistema de registro de plugins
5. **Refactorización de TaskListViewModel** - Desacoplado de la implementación de persistencia

---

## 🚀 Cómo Probar la Persistencia

### 1. Ejecutar la Aplicación

```bash
# Abrir el proyecto en Xcode
open TaskApp.xcodeproj

# Ejecutar con Cmd+R
```

### 2. Interactuar con la App

1. **Añadir tareas** - Las tareas se guardarán automáticamente
2. **Completar tareas** - El estado se persiste inmediatamente
3. **Cerrar la app** - Cmd+Q
4. **Volver a abrir** - Las tareas se cargarán automáticamente

### 3. Verificar el Archivo JSON

```bash
# Ver la ubicación del archivo
# La app imprimirá en consola la ruta completa

# Navegar al directorio (ejemplo)
cd ~/Library/Containers/com.yourcompany.TaskApp/Data/Documents/TaskAppData/

# Ver el contenido del archivo JSON
cat tasks.json | jq .
```

### 4. Ver Logs de Debug

En la consola de Xcode verás:
```
🚀 TaskApp iniciada
📦 Storage activo: json
🔌 Plugins disponibles: ["JSON"]
✅ Datos guardados exitosamente en: /path/to/tasks.json
📱 Tareas cargadas: 4
💾 Tareas guardadas: 5
```

---

## 🧪 Pruebas Manuales Recomendadas

### Test 1: Persistencia Básica
1. Añadir 3 tareas nuevas
2. Cerrar la app
3. Abrir la app
4. ✅ Verificar que las 3 tareas aparecen

### Test 2: Modificación
1. Completar 2 tareas
2. Cerrar la app
3. Abrir la app
4. ✅ Verificar que las 2 tareas siguen completadas

### Test 3: Eliminación
1. Eliminar una tarea (deslizar a la izquierda)
2. Cerrar la app
3. Abrir la app
4. ✅ Verificar que la tarea ya no existe

### Test 4: Datos Vacíos
1. Ejecutar: `TaskListViewModel.deleteAllTasks()`
2. Cerrar la app
3. Abrir la app
4. ✅ Verificar que se cargan las tareas de ejemplo

---

## 🔧 Configuración Avanzada

### Cambiar el Storage Provider

```swift
// En TaskApp.swift o AppConfig
AppConfig.shared.setStorageType(.json)

// Próximamente:
// AppConfig.shared.setStorageType(.swiftData)
```

### Activar/Desactivar Debug Mode

```swift
// En AppConfig.swift
static var debugMode: Bool = true  // false para producción
```

### Personalizar Ubicación de Almacenamiento

```swift
// Crear provider con directorio personalizado
let customProvider = JSONStorageProvider(directory: .cachesDirectory)
let viewModel = TaskListViewModel(storageProvider: customProvider)
```

---

## 📊 Estructura del JSON

El archivo `tasks.json` tiene la siguiente estructura:

```json
[
  {
    "id": "UUID-STRING",
    "title": "Nombre de la tarea",
    "isCompleted": false,
    "dueDate": "2025-10-29T12:00:00Z",
    "priority": "high",
    "reminderDate": null
  }
]
```

### Campos del Modelo Task

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | UUID | Identificador único |
| `title` | String | Nombre de la tarea |
| `isCompleted` | Bool | Estado de completado |
| `dueDate` | Date? | Fecha límite (opcional) |
| `priority` | Priority? | Prioridad: low, medium, high (opcional) |
| `reminderDate` | Date? | Fecha de recordatorio (opcional) |

---

## 🎨 Feature Flags Disponibles

```swift
// En AppConfig.swift

// UI Features
static var showDueDates: Bool = true
static var showPriorities: Bool = true

// Funcionalidades
static var enableReminders: Bool = true
static var enableStreaks: Bool = false
static var enableAdvancedStats: Bool = false
static var enableCloudSync: Bool = false

// Desarrollo
static var debugMode: Bool = true
```

---

## 🐛 Troubleshooting

### Problema: No se guardan las tareas

**Solución:**
1. Verificar que `debugMode = true`
2. Revisar la consola para errores
3. Verificar permisos del directorio Documents

### Problema: Error de decodificación

**Solución:**
1. Eliminar el archivo JSON corrupto
2. Relanzar la app (se crearán tareas de ejemplo)
3. Comando: `rm ~/Library/.../TaskAppData/tasks.json`

### Problema: Tareas duplicadas

**Solución:**
- El modelo `Task` usa UUID automático, las duplicaciones son normales si se copian manualmente

---

## 📈 Próximas Características

### Sesión 8: Plugin 2 - SwiftData
- [ ] Crear `SwiftDataStorageProvider`
- [ ] Implementar migración de JSON a SwiftData
- [ ] Queries y filtros avanzados

### Sesión 9: Sincronización
- [ ] CloudKit integration
- [ ] Resolución de conflictos
- [ ] Sincronización automática

---

## 💻 Comandos Útiles

### Limpiar el Storage

```swift
// En la app o en tests
let viewModel = TaskListViewModel()
viewModel.deleteAllTasks()
```

### Inspeccionar el Plugin Registry

```swift
let plugins = PluginRegistry.shared.availableStoragePlugins()
print("Plugins: \(plugins)")
```

### Verificar si existe archivo

```swift
let exists = AppConfig.shared.storageProvider.exists(forKey: "tasks")
print("Archivo existe: \(exists)")
```

---

## 📚 Conceptos Implementados

✅ **Dependency Inversion Principle (DIP)**
- ViewModels dependen de abstracciones (StorageProvider)
- Implementaciones concretas son intercambiables

✅ **Plugin Architecture**
- Sistema modular y extensible
- Fácil añadir nuevos storage providers

✅ **Dependency Injection**
- ViewModels reciben el StorageProvider
- Facilita testing con mocks

✅ **Protocol-Oriented Programming**
- Swift protocols como contratos
- Codable para serialización

✅ **Error Handling**
- Custom errors con LocalizedError
- Try/catch para operaciones que pueden fallar

---

## 🎓 Para Estudiantes

### Ejercicios Recomendados

1. **Añadir un nuevo campo al modelo Task**
   - Ejemplo: `notes: String?`
   - Actualizar el modelo y verificar que la persistencia funciona

2. **Crear un provider de UserDefaults**
   - Implementar `UserDefaultsStorageProvider`
   - Comparar con JSON provider

3. **Implementar export/import**
   - Método para exportar todas las tareas a un archivo
   - Método para importar tareas desde un archivo

4. **Añadir estadísticas**
   - Calcular tareas completadas por día
   - Persistir estadísticas en archivo separado

---

## 📞 Soporte

Si encuentras problemas:
1. Revisa los logs en consola de Xcode
2. Verifica que `debugMode = true`
3. Consulta `ARCHITECTURE.md` para detalles de implementación

---

**¡Feliz Coding! 🚀**
