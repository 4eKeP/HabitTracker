//
//  SeparatorsView.swift
//  TrackerYandexPracticum
//
//  Created by admin on 06.12.2023.
//

import UIKit

final class Separators {
    
    func addSeparators(for view: UIView, width: CGFloat, times: Int) {
        for time in 1...times {
            let separatorView = UIView()
            separatorView.frame = CGRect(x: CGFloat(16),
                                         y: CGFloat(75 * time),
                                         width: width,
                                         height: 2)
            separatorView.backgroundColor = .ypLightGray
            view.addSubview(separatorView)
        }
    }
}

