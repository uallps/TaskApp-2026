//
//  Task.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//
import Foundation

struct Task: Identifiable, Codable { 
    let id: UUID
    var title: String
    var isCompleted: Bool
    var dueDate: Date? 
    var priority: Priority?
    var reminderDate: Date?
    
    // Inicializador con valores por defecto
    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        dueDate: Date? = nil,
        priority: Priority? = nil,
        reminderDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.priority = priority
        self.reminderDate = reminderDate
    }
}

enum Priority: String, Codable, CaseIterable {
    case low = "Baja"
    case medium = "Media"
    case high = "Alta"
    
    var emoji: String {
        switch self {
        case .low: return "🟢"
        case .medium: return "🟡"
        case .high: return "🔴"
        }
    }
}
