//
//  ViewController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 24.11.2023.
//

import UIKit

class ViewController: UIViewController {

        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.white
            makeNavBar()
        }

    func makeNavBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: nil)
    }


}

