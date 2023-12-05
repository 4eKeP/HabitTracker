//
//  TrackersFactory.swift
//  TrackerYandexPracticum
//
//  Created by admin on 04.12.2023.
//

import Foundation


final class TrackersFactory {
    private (set) var trackers: [Tracker] = []
    private (set) var categories: [TrackerCategory] = []
    private (set) var complitedTrackers: [TrackerRecord] = []
    
    static let shared = TrackersFactory()
}
