//
//  Task.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//
import Foundation
import SwiftData

@Model
class Task: Identifiable {
    let id: UUID
    var title: String
    var isCompleted: Bool = false
    var dueDate: Date?
    var priority: Priority?
    var reminderDate: Date?
    
    init(title: String, isCompleted: Bool = false, dueDate: Date? = nil, priority: Priority? = nil, reminderDate: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.priority = priority
        self.reminderDate = reminderDate
    }
}


enum Priority: String, Codable {
    case low, medium, high
}
