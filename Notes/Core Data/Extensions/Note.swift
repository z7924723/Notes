//
//  Note.swift
//  Notes
//
//  Created by PinguMac on 2018/4/5.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import Foundation

extension Note {
  
  // Mark: - Dates
  var updatedAtAsDate: Date {
    return updatedAt ?? Date()
  }
  
  var createdAtAsDate: Date {
    return createdAt ?? Date()
  }
  
  // MARK: - Tags
  var alphabetizedTags: [Tag]? {
    guard let tags = tags as? Set<Tag> else {
      return nil
    }
    
    return tags.sorted(by: {
      guard let tag0 = $0.name else { return true }
      guard let tag1 = $1.name else { return true }
      return tag0 < tag1
    })
  }
  
  var alphabetizedTagsAsString: String? {
    guard let tags = alphabetizedTags, tags.count > 0 else {
      return nil
    }
    
    let names = tags.compactMap { $0.name }
    return names.joined(separator: ", ")
  }
  
}
