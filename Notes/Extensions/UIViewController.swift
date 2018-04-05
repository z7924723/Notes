//
//  UIViewController.swift
//  Notes
//
//  Created by PinguMac on 2018/4/5.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit

extension UIViewController {
  
  // MARK: - Alerts
  func showAlert(with title: String, and message: String) {
    // Initialize Alert Controller
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    // Configure Alert Controller
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    // Present Alert Controller
    present(alertController, animated: true, completion: nil)
  }
}
