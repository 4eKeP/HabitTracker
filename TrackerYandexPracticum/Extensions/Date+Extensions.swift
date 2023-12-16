//
//  Date+Extensions.swift
//  TrackerYandexPracticum
//
//  Created by admin on 07.12.2023.
//

import Foundation

extension Date {
  func weekdayFromMonday() -> Int {
    [0,7,1,2,3,4,5,6][Calendar.current.component(.weekday, from: self)]
  }
}
