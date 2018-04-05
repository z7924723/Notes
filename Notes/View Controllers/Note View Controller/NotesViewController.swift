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
  
  // MARK: - Properties
  private var coreDataManager = CoreDataManager(modelName: "Notes")

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let entityDescription = NSEntityDescription.entity(forEntityName: "Note", in: coreDataManager.managedObjectContext) {
      print(entityDescription.name ?? "No Name")
      print(entityDescription.properties)
      
      // Initialize Managed Object
//      let note = NSManagedObject(entity: entityDescription, insertInto: coreDataManager.managedObjectContext)
      // Initialize Note
      let note = Note(context: coreDataManager.managedObjectContext)
      
      // Configure Note
      note.title = "My Second Note"
      note.createdAt = Date()
      note.updatedAt = Date()

      do {
        try coreDataManager.managedObjectContext.save()
      } catch {
        print("Unable to Save Managed Object Context")
        print("\(error), \(error.localizedDescription)")
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

