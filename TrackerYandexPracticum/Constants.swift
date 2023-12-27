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
    
    static let categories = [
        "Важное"
    ]
    
    enum ConfigTypeConstants {
        
        static let leadingButton: CGFloat = 20
        
        static let leadingSpacing: CGFloat = 16
        
        static let settingHeight: CGFloat = 75
        
        static let titleSpacing: CGFloat = 28
        
        static let bottomSpacing: CGFloat = 24
        
        static let buttonHeight: CGFloat = 60
        
        static let settingsSectionHeight: CGFloat = 204
        
        static let configCollectionCellHeight: CGFloat = 52
        
        static let configCellsPerLine: CGFloat = 6
        
        static let configHeight: CGFloat = 20
        
        static var scrollViewHeight: CGFloat = 841
    }
    
    enum ScheduleConstants {
        
        static let switchWidth: CGFloat = 50
        
        static let switchHeight: CGFloat = 25
        
        static let leadingSpacing: CGFloat = 16
        
        static let switchFieldHeight: CGFloat = 75
        
        static let spacing: CGFloat = 16
        
        static let titleSpacing: CGFloat = 28
        
        static let bottomSpacing: CGFloat = 24
        
        static let buttonHeight: CGFloat = 60
    }
    
    enum TrackerTypeConstants {
        static let leadingButton: CGFloat = 20
        
        static let buttonHeight: CGFloat = 60
        
        static let buttonSpacing: CGFloat = 16
    }
    
    enum StatsConstants {
        static let spacingFromTitle: CGFloat = 56
    }
    
    enum TrackerControllerConstants {
        static let trackersPerLine: CGFloat = 2
        
        static let smallSpacing: CGFloat = 9
        
        static let spacing: CGFloat = 16
        
        static let collectionHeight:CGFloat = 148
        
        static let sectionHeight: CGFloat = 46
    }
}
