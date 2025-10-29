//
//  Date+Extensions.swift
//  TaskApp
//
//  Created by Francisco José García García on 28/10/25.
//

import Foundation

extension Date {
    
    /// Formatea la fecha para mostrar en la UI
    /// - Returns: String con formato legible
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    /// Retorna solo la fecha (sin hora)
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// Verifica si la fecha es hoy
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    /// Verifica si la fecha es mañana
    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }
    
    /// Verifica si la fecha ya pasó
    var isPast: Bool {
        self < Date()
    }
    
    /// Retorna una representación relativa de la fecha
    var relativeFormatted: String {
        if isToday {
            return "Hoy"
        } else if isTomorrow {
            return "Mañana"
        } else if isPast {
            return "Vencida"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: self)
        }
    }
}
