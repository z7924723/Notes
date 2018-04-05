//
//  ViewController.swift
//  Notes
//
//  Created by PinguMac on 2018/4/3.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {
  
  // MARK: - Segues
  private enum Segue {
    static let AddNote = "AddNote"
  }
  
  // MARK: - Properties
  private var coreDataManager = CoreDataManager(modelName: "Notes")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    
    switch identifier {
    case Segue.AddNote:
      guard let destination = segue.destination as? AddNoteViewController else {
        return
      }
      
      // Configure Destination
      destination.managedObjectContext = coreDataManager.managedObjectContext
      
    default:
      break
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

