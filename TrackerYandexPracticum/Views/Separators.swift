//
//  SeparatorsView.swift
//  TrackerYandexPracticum
//
//  Created by admin on 06.12.2023.
//

import UIKit

final class Separators {
    
    private let spacing = Resources.Separators.spacing
    private let fieldHeight = Resources.Separators.fieldHeight
    private let separatorHeight = Resources.Separators.separatorHeight
    
    func addSeparators(for view: UIView, width: CGFloat, times: Int) {
        for time in 1...times {
            let separatorView = UIView()
            separatorView.frame = CGRect(x: spacing,
                                         y: fieldHeight * CGFloat(time),
                                         width: width,
                                         height: separatorHeight)
            separatorView.backgroundColor = .ypGray
            view.addSubview(separatorView)
        }
    }
}

