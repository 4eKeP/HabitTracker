//
//  TrackerYandexPracticumTests.swift
//  TrackerYandexPracticumTests
//
//  Created by admin on 10.03.2024.
//

import XCTest
import SnapshotTesting
@testable import TrackerYandexPracticum

final class TrackerYandexPracticumTests: XCTestCase {

    func testVC() {
        let vc = TabBarController()
        isRecording = false
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
}
