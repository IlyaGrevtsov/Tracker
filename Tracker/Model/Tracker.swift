//
//  Tracker.swift
//  tracker
//
//  Created by Илья on 19.10.2024.
//

import UIKit
import Foundation

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [String]
    
    init(id: UUID, name: String, color: UIColor, emoji: String, schedule: [String]) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
}
enum weekDay: Int, CaseIterable {
    case monday = 1
    case tuersday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 0
    
    var stringValue: String {
        switch self {
        case .monday: return "Пн"
        case .tuersday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
    
}

enum TrackerType {
    case habit
    case event
}
struct MockTracker {
    let mockColors: [UIColor] = [.red, .blue, .green, .yellow, .purple, .orange]
    let mockEmojis: [String] = ["👦", "👨🏻‍💻", "🤩", "😄", "😓"]
}
