//
//  Constant.swift
//  tracker
//
//  Created by Илья on 19.10.2024.
//

import Foundation
import UIKit

enum Constant {
    static let emoji = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🌴", "😪",
    ]
    
    static let dayName = [
    "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье",
    ]
    
    static let colorSelection = (1...18).map({ UIColor(named: String($0)) })
    static let collectionViewTitles = ["Emoji", "Цвет"]
}
enum Colors {
    static let buttonActive = UIColor.black
    static let buttonInactive = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
    static let cancelButtonColor = UIColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1.0)
    static let textFieldBackground = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
    static let switchViewColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1.0)
}
extension Constant {
    static func randomEmoji() -> String {
        return emoji.randomElement() ?? "🤪"
    }
}
