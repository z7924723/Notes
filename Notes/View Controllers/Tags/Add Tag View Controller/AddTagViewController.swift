//
//  AddTagViewController.swift
//  Notes
//
//  Created by PinguMac on 2018/4/12.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit
import CoreData

class AddTagViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var nameTextField: UITextField!
  
  // MARK: -
  var managedObjectContext: NSManagedObjectContext?
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Add Tag"
    
    setupView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // Show Keyboard
    nameTextField.becomeFirstResponder()
  }
  
  // MARK: - View Methods
  private func setupView() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save(sender:)))
  }
  
  // MARK: - Actions
  @IBAction func save(sender: UIBarButtonItem) {
    guard let managedObjectContext = managedObjectContext else { return }
    
    guard let name = nameTextField.text, !name.isEmpty else {
      showAlert(with: "Name Missing", and: "Your tag doesn't have a name.")
      return
    }
    
    // Create Tag
    let tag = Tag(context: managedObjectContext)
    
    // Configure Tag
    tag.name = nameTextField.text
    
    // Pop View Controller
    _ = navigationController?.popViewController(animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
