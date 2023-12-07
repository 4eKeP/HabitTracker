//
//  Constants.swift
//  TrackerYandexPracticum
//
//  Created by admin on 07.12.2023.
//

import UIKit

enum Constants {
    static let emojis = [
      "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"
    ]
    
    static let colors: [UIColor] = [
      .ypHabitColor01, .ypHabitColor02, .ypHabitColor03, .ypHabitColor04, .ypHabitColor05, .ypHabitColor06,
      .ypHabitColor07, .ypHabitColor08, .ypHabitColor09, .ypHabitColor10, .ypHabitColor11, .ypHabitColor12,
      .ypHabitColor13, .ypHabitColor14, .ypHabitColor15, .ypHabitColor16, .ypHabitColor17, .ypHabitColor18
    ]
    
    static let dateFormat = "dd.MM.YYYY"
    
    static let dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = Constants.dateFormat
      return dateFormatter
    }()
}
