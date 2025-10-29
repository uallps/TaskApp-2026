//
//  JSONStorageProvider.swift
//  TaskApp
//
//  Created by Francisco José García García on 28/10/25.
//

import Foundation

/// Plugin 1: Implementación de persistencia usando JSON y FileManager
/// Esta clase implementa el protocolo StorageProvider usando el sistema de archivos local
class JSONStorageProvider: StorageProvider {
    
    // MARK: - Properties
    
    /// Directorio base donde se guardarán los archivos JSON
    private let baseDirectory: URL
    
    /// Codificador JSON con formato legible
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    /// Decodificador JSON
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    // MARK: - Initialization
    
    /// Inicializa el proveedor de almacenamiento JSON
    /// - Parameter directory: Directorio donde se guardarán los archivos (por defecto: Documents)
    init(directory: FileManager.SearchPathDirectory = .documentDirectory) {
        // Obtener el directorio de documentos del usuario
        let paths = FileManager.default.urls(for: directory, in: .userDomainMask)
        self.baseDirectory = paths[0].appendingPathComponent("TaskAppData", isDirectory: true)
        
        // Crear el directorio si no existe
        createDirectoryIfNeeded()
    }
    
    // MARK: - Private Methods
    
    /// Crea el directorio base si no existe
    private func createDirectoryIfNeeded() {
        if !FileManager.default.fileExists(atPath: baseDirectory.path) {
            try? FileManager.default.createDirectory(
                at: baseDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
    }
    
    /// Obtiene la URL del archivo para una clave específica
    /// - Parameter key: Identificador único del conjunto de datos
    /// - Returns: URL completa del archivo JSON
    private func fileURL(forKey key: String) -> URL {
        return baseDirectory.appendingPathComponent("\(key).json")
    }
    
    // MARK: - StorageProvider Protocol Implementation
    
    func save<T: Codable>(_ items: [T], forKey key: String) throws {
        do {
            // Codificar los datos a JSON
            let data = try encoder.encode(items)
            
            // Obtener la URL del archivo
            let fileURL = fileURL(forKey: key)
            
            // Escribir los datos al archivo
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            
            print("✅ Datos guardados exitosamente en: \(fileURL.path)")
        } catch let encodingError as EncodingError {
            throw StorageError.encodingFailed(encodingError)
        } catch {
            throw StorageError.saveFailed(error)
        }
    }
    
    func load<T: Codable>(forKey key: String) throws -> [T] {
        let fileURL = fileURL(forKey: key)
        
        // Verificar si el archivo existe
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("ℹ️ No se encontró archivo para la clave '\(key)', retornando array vacío")
            return []
        }
        
        do {
            // Leer los datos del archivo
            let data = try Data(contentsOf: fileURL)
            
            // Decodificar los datos
            let items = try decoder.decode([T].self, from: data)
            
            print("✅ Datos cargados exitosamente desde: \(fileURL.path) (\(items.count) elementos)")
            return items
        } catch let decodingError as DecodingError {
            throw StorageError.decodingFailed(decodingError)
        } catch {
            throw StorageError.invalidData
        }
    }
    
    func delete(forKey key: String) throws {
        let fileURL = fileURL(forKey: key)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("ℹ️ No hay archivo que eliminar para la clave '\(key)'")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("✅ Archivo eliminado exitosamente: \(fileURL.path)")
        } catch {
            throw StorageError.deleteFailed(error)
        }
    }
    
    func exists(forKey key: String) -> Bool {
        let fileURL = fileURL(forKey: key)
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
    
    // MARK: - Utility Methods
    
    /// Obtiene el path completo del archivo para debugging
    /// - Parameter key: Identificador único del conjunto de datos
    /// - Returns: String con el path completo
    func getFilePath(forKey key: String) -> String {
        return fileURL(forKey: key).path
    }
    
    /// Lista todos los archivos JSON en el directorio
    /// - Returns: Array de nombres de archivos
    func listAllFiles() -> [String] {
        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: baseDirectory,
                includingPropertiesForKeys: nil
            )
            return contents
                .filter { $0.pathExtension == "json" }
                .map { $0.lastPathComponent }
        } catch {
            return []
        }
    }
}
