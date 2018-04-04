//
//  ViewController.swift
//  Notes
//
//  Created by PinguMac on 2018/4/3.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  
  // MARK: - Properties
  private var coreDataManager = CoreDataManager(modelName: "Notes")

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let entityDescription = NSEntityDescription.entity(forEntityName: "Note", in: coreDataManager.managedObjectContext) {
      print(entityDescription.name ?? "No Name")
      print(entityDescription.properties)
      
      // Initialize Managed Object
      let note = NSManagedObject(entity: entityDescription, insertInto: coreDataManager.managedObjectContext)
      
      // Configure Managed Object
      note.setValue("My First Note", forKey: "title")
      note.setValue(NSDate(), forKey: "createdAt")
      note.setValue(NSDate(), forKey: "updatedAt")

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

