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
    case monday = 0
    case tuersday = 1
    case wednesday = 2
    case thursday = 3
    case friday = 4
    case saturday = 5
    case sunday = 6
    
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
