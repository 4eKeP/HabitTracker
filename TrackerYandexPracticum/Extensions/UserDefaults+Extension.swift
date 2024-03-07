//
//  UserDefaults+Extension.swift
//  TrackerYandexPracticum
//
//  Created by admin on 09.01.2024.
//

import Foundation

extension UserDefaults {
    private enum Keys: String {
        case isOnBoarded
        case pinnedCategoryID
    }
    
    var isOnBoarded: Bool {
        get {
            bool(forKey: Keys.isOnBoarded.rawValue)
        }
        set {
            setValue(newValue, forKey: Keys.isOnBoarded.rawValue)
        }
    }
    
    var pinnedCategoryID: String {
        get {
            string(forKey: Keys.pinnedCategoryID.rawValue) ?? ""
        }
        set {
            setValue(newValue, forKey: Keys.pinnedCategoryID.rawValue)
        }
    }
    
}
