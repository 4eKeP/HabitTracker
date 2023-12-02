//
//  Tracker.swift
//  TrackerYandexPracticum
//
//  Created by admin on 30.11.2023.
//

import Foundation

struct Tracker {
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let schedule: Date
}

struct TrackerCategory {
    let id: UUID
    let categoryName: String
    let trackers: [Tracker]
}

struct TrackerRecord {
    let id: UUID
    let isDone: Bool
    let doneDate: Date
}
