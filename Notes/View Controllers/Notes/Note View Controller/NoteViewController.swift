//
//  NoteViewController.swift
//  Notes
//
//  Created by PinguMac on 2018/4/6.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication

class NoteViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var tagsLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var contentsTextView: UITextView!
  @IBOutlet weak var lockView: UIView!
  
  // MARK: - Segues
  private enum Segue {
    static let Tags = "Tags"
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
      
    case Segue.Tags:
      guard let destination = segue.destination as? TagsViewController else {
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
    setupLockView()
    setupTagsLabel()
    setupCategoryLabel()
    setupTitleTextField()
    setupContentsTextView()
  }
  
  // MARK: -
  private func setupLockView() {
    if (note?.isLock)! {
      lockView.isHidden = false
      self.navigationItem.rightBarButtonItems![0].image = UIImage(named: "TableLock.png")
    } else {
      lockView.isHidden = true
      self.navigationItem.rightBarButtonItems![0].image = UIImage(named: "TableUnlock.png")
    }
  }
  
  private func setupTagsLabel() {
    updateTagsLabel()
  }
  
  private func updateTagsLabel() {
    // Configure Tags Label
    tagsLabel.text = note?.alphabetizedTagsAsString ?? "No Tags"
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
      updateTagsLabel()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Tap Gesture Action
  @IBAction func didTapAuthCheck(_ sender: Any) {
    let laContext: LAContext = LAContext()
    
    if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
      laContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock with finger print") { (wasCorrect, error) in
        if wasCorrect {
          DispatchQueue.main.async {
            self.note?.isLock = false
            self.lockView.isHidden = true
            self.navigationItem.rightBarButtonItems![0].image = UIImage(named: "TableUnlock.png")
          }
        } else {
          print(error.debugDescription)
          return
        }
      }
    } else {
      print("not support touch id")
    }
  }
  
  @IBAction func didTapLock(_ sender: Any) {
    guard note?.isLock == true else {
      self.navigationItem.rightBarButtonItems![0].image = UIImage(named: "TableLock.png")
      self.lockView.isHidden = false
      self.note?.isLock = true
      return
    }
    didTapAuthCheck(note?.isLock)
  }
  
}
