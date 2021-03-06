//
//  AddNoteViewController.swift
//  Notes
//
//  Created by PinguMac on 2018/4/5.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var contentsTextView: UITextView!
  
  // MARK: -
  var managedObjectContext: NSManagedObjectContext?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Add Note"
    
    setupView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // Show Keyboard
    titleTextField.becomeFirstResponder()
  }
  
  // MARK: - View Methods
  private func setupView() {
    setupContentsTextView()
  }
  
  // MARK: -
  private func setupContentsTextView() {
    contentsTextView.delegate = self
    contentsTextView.text = "Input note text here."
    contentsTextView.textColor = UIColor.lightGray
  }
  
  // MARK: - Actions
  @IBAction func save(_ sender: UIBarButtonItem) {
    guard let managedObjectContext = managedObjectContext else { return }
    guard let title = titleTextField.text, !title.isEmpty else {
      showAlert(with: "Title Missing", and: "Your note doesn't have a title.")
      return
    }
    
    // Create Note
    let note = Note(context: managedObjectContext)
    
    // Configure Note
    note.createdAt = Date()
    note.updatedAt = Date()
    note.title = title
    note.contents = contentsTextView.text
    note.isLock = false
    
    // Pop View Controller
    _ = navigationController?.popViewController(animated: true)
  }
  
}

extension AddNoteViewController: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if contentsTextView.textColor == UIColor.lightGray {
      contentsTextView.text = ""
      contentsTextView.textColor = UIColor.black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if contentsTextView.text == "" {
      contentsTextView.text = "Input note text here."
      contentsTextView.textColor = UIColor.lightGray
    }
  }

}
