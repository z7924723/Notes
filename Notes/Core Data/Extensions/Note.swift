//
//  Note.swift
//  Notes
//
//  Created by PinguMac on 2018/4/5.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import Foundation

extension Note {
  
  var updatedAtAsDate: Date {
    return updatedAt ?? Date()
  }
  
  var createdAtAsDate: Date {
    return createdAt ?? Date()
  }
  
}
