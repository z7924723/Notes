//
//  NoteViewController.swift
//  Notes
//
//  Created by PinguMac on 2018/4/6.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var contentTextField: UITextView!
  
  // MARK: -
  var note: Note?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Edit Note"
    
    setupView()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Update Title
    if let title = titleTextField.text, !title.isEmpty && note?.title != title {
      note?.title = title
    }
    
    // Update Contents
    if note?.contents != contentTextField.text {
      note?.contents = contentTextField.text
    }
    
    // Update Updated At
    if (note?.isUpdated)! {
      note?.updatedAt = Date()
    }
  }
  
  private func setupView() {
    setupTitleTextField()
    setupContentsTextView()
  }
  
  private func setupTitleTextField() {
    // Configure Title Text Field
    titleTextField.text = note?.title
  }
  
  private func setupContentsTextView() {
    // Configure Contents Text View
    contentTextField.text = note?.contents
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
