//
//  TrckerStoreUpdate.swift
//  TrackerYandexPracticum
//
//  Created by admin on 25.12.2023.
//

import Foundation

struct TrackerStoreUpdate {
    let insertedIndexes: [IndexPath]
    let deletedIndexes: [IndexPath]
    let updatedIndexes: [IndexPath]
}

struct TrackerCategoryStoreUpdate {
    let insertedSectionIndexes: IndexSet
    let deletedSectionIndexes: IndexSet
    let updatedSectionIndexes: IndexSet
}
