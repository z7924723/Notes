//
//  CategoryViewController.swift
//  Notes
//
//  Created by PinguMac on 2018/4/9.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
  
  @IBOutlet weak var nameTextField: UITextField!
  
  // MARK: -
  var category: Category?
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Edit Category"
    
    setupView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Update Category
    if let name = nameTextField.text, !name.isEmpty {
      category?.name = name
    }
  }
  
  // MARK: - View Methods
  private func setupView() {
    setupNameTextField()
  }
  
  // MARK: -
  private func setupNameTextField() {
    // Configure Name Text Field
    nameTextField.text = category?.name
  }
}
