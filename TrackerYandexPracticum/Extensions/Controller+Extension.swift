//
//  Controller+Extension.swift
//  TrackerYandexPracticum
//
//  Created by admin on 08.12.2023.
//

import UIKit

extension UIViewController {

  @objc func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
}
