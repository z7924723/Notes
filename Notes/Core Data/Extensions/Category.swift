//
//  Category.swift
//  Notes
//
//  Created by PinguMac on 2018/4/12.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit

extension Category {
  
  var color: UIColor? {
    get {
      guard let hex = colorAsHex else { return nil }
      return UIColor(hex: hex)
    }
    
    set(newColor) {
      if let newColor = newColor {
        colorAsHex = newColor.toHex
      }
    }
  }
  
}
