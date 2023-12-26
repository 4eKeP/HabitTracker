//
//  Date+Extensions.swift
//  TrackerYandexPracticum
//
//  Created by admin on 07.12.2023.
//

import Foundation

extension Date {
  func weekdayFromMonday() -> Int {
      let day = [0,7,1,2,3,4,5,6][Calendar.current.component(.weekday, from: self)]
      print(day)
      return day
  //
  }
    
    func sameDay(_ date: Date) -> Bool {
      Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedSame
    }

    func beforeDay(_ date: Date) -> Bool {
      Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedAscending
    }
}
