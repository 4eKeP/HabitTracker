//
//  Resources.swift
//  TrackerYandexPracticum
//
//  Created by admin on 07.12.2023.
//

import UIKit

enum Resources {
    static let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"
    ]
    
    static let colors: [UIColor] = [
        .ypHabitColor01, .ypHabitColor02, .ypHabitColor03, .ypHabitColor04, .ypHabitColor05, .ypHabitColor06,
        .ypHabitColor07, .ypHabitColor08, .ypHabitColor09, .ypHabitColor10, .ypHabitColor11, .ypHabitColor12,
        .ypHabitColor13, .ypHabitColor14, .ypHabitColor15, .ypHabitColor16, .ypHabitColor17, .ypHabitColor18
    ]
    
    static let pinCategoriesName = NSLocalizedString("labels.pinCategoryName", comment: "Name for pinned Category")
    
    enum ContextMenuList {
        
        static let pin = NSLocalizedString("labels.context.pin", comment: "label for context menu - pin")
        static let edit = NSLocalizedString("labels.context.edit", comment: "label for context menu - edit")
        static let delete = NSLocalizedString("labels.context.delete", comment: "label for context menu - delete")
        static let unpin = NSLocalizedString("labels.context.unpin", comment: "label for context menu - unpin")
        static let confirmTrackerDelete = NSLocalizedString("labels.confirmTrackerDelete", comment: "")
        static let cancel = NSLocalizedString("labels.cancel", comment: "label for cancel")
        
        static let unpinImage = UIImage(systemName: "pin.slash")
        static let pinImage = UIImage(systemName: "pin")
        static let pinFillImage = UIImage(systemName: "pin.fill")
        static let editImage = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
        static let deleteImage = UIImage(systemName: "trash")
        
    }
    
    enum TrackerCellConstants {
       static let height: CGFloat = 90
       static let spacing: CGFloat = 12
       static let smallSpacing: CGFloat = 8
       static let bigSpacing: CGFloat = 16
       static let cornerRadius: CGFloat = 32
       static let emojiHeight: CGFloat = 24
    }
    
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
        
        enum Labels {
            
            static let titleLabelTextNewHabit = NSLocalizedString("labels.newHabit", comment: "")
            
            static let titleLabelTextNewEvent = NSLocalizedString("labels.newEvent", comment: "")
            
            static let titleTextFieldPlaceholder = NSLocalizedString("labels.textFieldPlaceholder", comment: "")
            
            static let warningLabelText =  NSLocalizedString("labels.textFieldRestriction", comment: "")
            
            static let categoryButtonText = NSLocalizedString("labels.category", comment: "")
            
            static let scheduleButtonText = NSLocalizedString("labels.schedule", comment: "")
            
            static let cancelButtonText = NSLocalizedString("labels.cancel", comment: "")
            
            static let createButtonText = NSLocalizedString("labels.create", comment: "")
            
            static let fullWeekText = NSLocalizedString("labels.everyDays", comment: "")
            
            static let workDaysText = NSLocalizedString("labels.weekDays", comment: "")
            
            static let weekendsText = NSLocalizedString("labels.weekEnds", comment: "")
            static let collectionTypeEmojiText = NSLocalizedString("labels.emoji", comment: "")
            
            static let collectionTypeColorText = NSLocalizedString("labels.color", comment: "")
            
            static let shortWeekDays = Calendar.autoupdatingCurrent.shortWeekdaySymbols.shift()
        }
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
        
        enum Labels {
            static let headerText = NSLocalizedString("labels.schedule", comment: "")
            
            static let doneButtonText = NSLocalizedString("labels.done", comment: "")
        }
    }
    
    enum TrackerTypeConstants {
        static let leadingButton: CGFloat = 20
        
        static let buttonHeight: CGFloat = 60
        
        static let buttonSpacing: CGFloat = 16
        
        enum Labels {
            static let titleLabelText = NSLocalizedString("labels.newTracker", comment: "")
            
            static let addHabitButtonText = NSLocalizedString("labels.habit", comment: "")
            
            static let addEventButtonText = NSLocalizedString("labels.event", comment: "")
        }
    }
    
    enum StatsConstants {
        static let spacingFromTitle: CGFloat = 56
        
        enum Labels {
            static let emptyViewText = NSLocalizedString("labels.emptyTracker", comment: "")
        }
    }
    
    enum TrackerControllerConstants {
        static let trackersPerLine: CGFloat = 2
        
        static let smallSpacing: CGFloat = 9
        
        static let spacing: CGFloat = 16
        
        static let collectionHeight:CGFloat = 148
        
        static let sectionHeight: CGFloat = 46
        
        enum Labels {
            static let searchBarPlaceHolderText = NSLocalizedString("labels.searchBar", comment: "")
            
            static let cancelButtonText = NSLocalizedString("labels.cancel", comment: "")
            
            static let emptyViewText = NSLocalizedString("labels.emptyTracker", comment: "")
            
            static let emptyViewSearchText = NSLocalizedString("labels.emptySearch", comment: "")
        }
    }
    
    enum CategoryCellConstants {
        static let categoryButtonLeading: CGFloat = 20
        
        static let leadingOffset: CGFloat = 16
        
        static let categoryLabelHeight: CGFloat = 24
        
        static let doneButtonSize: CGFloat = 20
        
    }
    
    enum CategoryViewControllerConstants {
        
        static let categoryOffset: CGFloat = 24
        
        static let titleSpacing: CGFloat = 28
        
        static let titleHeight: CGFloat = 42
        
        static let buttonHeight: CGFloat = 60
        
        static let categoryFieldHeight: CGFloat = 75
        
        enum Labels {
            static let categoryText = NSLocalizedString("labels.category", comment: "")
            
            static let emptyViewText = NSLocalizedString("labels.emptyCategory", comment: "")
            
            static let addButtonText = NSLocalizedString("labels.addCategory", comment: "")
        }
        
    }
    
    enum AddCategoryViewControllerConstants {
        
        static let addcategoryOffset: CGFloat = 24
        
        static let titleHeight: CGFloat = 42
        
        static let titleSpacing: CGFloat = 28
        
        static let addCategoryFieldHeight: CGFloat = 75
        
        static let buttonHeight: CGFloat = 60
        
        enum Labels {
            static let titleLabelText = NSLocalizedString("labels.newCategory", comment: "")
            
            static let textFieldPlaceHolderText = NSLocalizedString("labels.categoryNamePlaceholder", comment: "")
            
            static let addButtonText = NSLocalizedString("labels.addCategory", comment: "")
        }
    }
    
    enum OnBoardingControllerConstants {
        
        static let leadingOnBoardingPage: CGFloat = 20
        
        static let centerOffsetOrButtonHeight: CGFloat = 60
        
        static let bottomSpacing: CGFloat = 84
        
        static let bottomPageControllOffset: CGFloat = 134
        
        enum Labels {
            static let blueControllerText = NSLocalizedString("labels.onboardingPage1", comment: "")
            
            static let redControllerText = NSLocalizedString("labels.onboardingPage2", comment: "")
            
            static let buttonTitleText = NSLocalizedString("labels.onboardingButton", comment: "")
        }
    }
    
    enum TabBarConstants {
        
        static let borderHeight: CGFloat = 0.5
        
        enum Labels {
            static let tabBarTrackerText = NSLocalizedString("labels.trackers", comment: "")
            
            static let tabBarStatsText = NSLocalizedString("labels.statistic", comment: "")
        }
    }
    
    enum Separators {
        static let spacing: CGFloat = 16
        static let fieldHeight: CGFloat = 75
        static let separatorHeight: CGFloat = 0.5
    }
}
