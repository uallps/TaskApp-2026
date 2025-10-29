//
//  StorageProvider.swift
//  TaskApp
//
//  Created by Francisco José García García on 28/10/25.
//

import Foundation

/// Protocolo que define el contrato para cualquier sistema de persistencia
/// Aplicando el Principio de Inversión de Dependencias:
/// - Las capas superiores (ViewModels) dependen de esta abstracción
/// - Las implementaciones concretas (JSON, SwiftData, etc.) dependen de esta abstracción
protocol StorageProvider {
    /// Guarda una colección de elementos
    /// - Parameters:
    ///   - items: Array de elementos a guardar
    ///   - key: Identificador único para este conjunto de datos
    func save<T: Codable>(_ items: [T], forKey key: String) throws
    
    /// Carga una colección de elementos
    /// - Parameter key: Identificador único del conjunto de datos
    /// - Returns: Array de elementos o un array vacío si no existen datos
    func load<T: Codable>(forKey key: String) throws -> [T]
    
    /// Elimina todos los datos asociados a una clave
    /// - Parameter key: Identificador único del conjunto de datos
    func delete(forKey key: String) throws
    
    /// Verifica si existen datos para una clave específica
    /// - Parameter key: Identificador único del conjunto de datos
    /// - Returns: true si existen datos, false en caso contrario
    func exists(forKey key: String) -> Bool
}

/// Errores personalizados para operaciones de almacenamiento
enum StorageError: LocalizedError {
    case encodingFailed(Error)
    case decodingFailed(Error)
    case fileNotFound
    case saveFailed(Error)
    case deleteFailed(Error)
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .encodingFailed(let error):
            return "Error al codificar datos: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Error al decodificar datos: \(error.localizedDescription)"
        case .fileNotFound:
            return "No se encontró el archivo de datos"
        case .saveFailed(let error):
            return "Error al guardar datos: \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "Error al eliminar datos: \(error.localizedDescription)"
        case .invalidData:
            return "Los datos son inválidos o están corruptos"
        }
    }
}
