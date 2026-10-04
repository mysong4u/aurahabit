import Foundation
import SwiftData
import SwiftUI

@Model
final class Habit {
    var id: UUID = UUID()
    var title: String = ""
    var iconName: String = "star.fill"
    var colorHex: String = "#FF2D55"
    var createdAt: Date = Date()
    
    // Relationship
    @Relationship(deleteRule: .cascade) var sessions: [FocusSession] = []
    
    // Daily completion tracking (simple representation: dates when completed)
    var completedDates: [Date] = []
    
    init(title: String, iconName: String = "star.fill", colorHex: String = "#FF2D55") {
        self.title = title
        self.iconName = iconName
        self.colorHex = colorHex
    }
    
    var color: Color {
        Color(hex: colorHex) ?? .blue
    }
    
    func isCompleted(on date: Date) -> Bool {
        let calendar = Calendar.current
        return completedDates.contains { calendar.isDate($0, inSameDayAs: date) }
    }
    
    func toggleCompletion(for date: Date = Date()) {
        let calendar = Calendar.current
        if let index = completedDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) }) {
            completedDates.remove(at: index)
        } else {
            completedDates.append(date)
        }
    }
}

@Model
final class FocusSession {
    var id: UUID = UUID()
    var durationInSeconds: Int = 0
    var date: Date = Date()
    
    var habit: Habit?
    
    init(durationInSeconds: Int, date: Date = Date(), habit: Habit? = nil) {
        self.durationInSeconds = durationInSeconds
        self.date = date
        self.habit = habit
    }
}

// Extension to convert Hex string to SwiftUI Color
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let length = hexSanitized.count
        let r, g, b, a: Double
        if length == 6 {
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
            a = 1.0
        } else if length == 8 {
            r = Double((rgb & 0xFF000000) >> 24) / 255.0
            g = Double((rgb & 0x00FF0000) >> 16) / 255.0
            b = Double((rgb & 0x0000FF00) >> 8) / 255.0
            a = Double(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
