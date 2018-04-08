//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by PinguMac on 2018/4/5.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
  
  // MARK: - Static Properties
  static let reuseIdentifier = "NoteTableViewCell"
  
  // MARK: - Properties
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var contentsLabel: UILabel!
  @IBOutlet weak var updatedAtLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
