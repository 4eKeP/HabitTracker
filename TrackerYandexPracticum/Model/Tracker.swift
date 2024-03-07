//
//  Tracker.swift
//  TrackerYandexPracticum
//
//  Created by admin on 30.11.2023.
//

import Foundation

struct Tracker: Hashable {
    let id: UUID
    let name: String
    let color: Int
    let emoji: Int
    let schedule: [Bool]
    let isPinned: Bool
}

struct TrackerCategory: Hashable {
    let id: UUID
    let categoryName: String
    let trackers: [Tracker]
}

struct TrackerRecord: Hashable {
    let id: UUID
    let tracker: Tracker
    let dates: [Date]
    let days: Int
}
