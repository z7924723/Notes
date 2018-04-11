//
//  NoteViewController.swift
//  Notes
//
//  Created by PinguMac on 2018/4/6.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var contentsTextView: UITextView!
  
  // MARK: - Segues
  private enum Segue {
    static let Categories = "Categories"
  }
  
  // MARK: -
  var note: Note?
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Edit Note"
    
    setupView()
    
    setupNotificationHandling()
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    guard let note = note else { return }
    
    // Update Title
    if let title = titleTextField.text, !title.isEmpty && note.title != title {
      note.title = title
    }
    
    // Update Contents
    if note.contents != contentsTextView.text {
      note.contents = contentsTextView.text
    }
    
    // Update Updated At
    if note.isUpdated {
      note.updatedAt = Date()
    }
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    
    switch identifier {
    case Segue.Categories:
      guard let destination = segue.destination as? CategoriesViewController else {
        return
      }
      
      // Configure Destination
      destination.note = note
      
    default:
      break
    }
  }
  
  // MARK: - View Methods
  private func setupView() {
    setupCategoryLabel()
    setupTitleTextField()
    setupContentsTextView()
  }
  
  // MARK: -
  private func setupTitleTextField() {
    // Configure Title Text Field
    titleTextField.text = note?.title
  }
  
  private func setupContentsTextView() {
    // Configure Contents Text View
    contentsTextView.text = note?.contents
  }
  
  private func setupCategoryLabel() {
    updateCategoryLabel()
  }
  
  private func updateCategoryLabel() {
    // Configure Category Label
    categoryLabel.text = note?.category?.name ?? "No Category"
  }
  
  // MARK: - Helper Methods
  private func setupNotificationHandling() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(managedObjectContextObjectsDidChange(_:)),
                                           name: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                           object: note?.managedObjectContext)
  }
  
  // MARK: - Notification Handling
  @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
    guard let userInfo = notification.userInfo else {
      return
    }
    
    guard let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> else {
      return
    }
    
    if (updates.filter { return $0 == note }).count > 0 {
      updateCategoryLabel()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
