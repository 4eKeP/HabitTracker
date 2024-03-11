//
//  AnalyticService.swift
//  TrackerYandexPracticum
//
//  Created by admin on 06.03.2024.
//

import Foundation
import AppMetricaCore


final class AnalyticService {
    
    static private let apiMetricaKey: String = "ab780a68-5970-459e-b592-9ce14172344b"
    
    static let shared = AnalyticService()
    
    static func activate() {
        let configuration = AppMetricaConfiguration(apiKey: self.apiMetricaKey)
            AppMetrica.activate(with: configuration!)
    }
    
    func report(name: String, parameters: [AnyHashable : Any]) {
        
        AppMetrica.reportEvent(name: name, parameters: parameters) { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        }
    }
}
