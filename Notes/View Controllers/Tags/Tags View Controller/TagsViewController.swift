//
//  TagsViewController.swift
//  Notes
//
//  Created by PinguMac on 2018/4/12.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit

class TagsViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Segues
  private enum Segue {
    static let Tag = "Tag"
    static let AddTag = "AddTag"
  }
  
  // MARK: -
  var note: Note?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Tags"
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
