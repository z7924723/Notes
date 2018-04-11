//
//  CoreDataManager.swift
//  Notes
//
//  Created by PinguMac on 2018/4/3.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import CoreData

final class CoreDataManager {
  // MARK: - Properties
  private let modelName: String
  
  // MARK: -
  private(set) lazy var managedObjectContext: NSManagedObjectContext = {
    // Initialize Managed Object Context
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    // Configure Managed Object Context
    managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
    
    return managedObjectContext
  }()
  
  private lazy var managedObjectModel: NSManagedObjectModel = {
    // Fetch Model URL
    guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
      fatalError("Unable to Find Data Model")
    }
    
    // Initialize Managed Object Model
    guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("Unable to Load Data Model")
    }
    
    return managedObjectModel
  }()
  
  private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    // Initialize Persistent Store Coordinator
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    
    // Helpers
    let fileManager = FileManager.default
    let storeName = "\(self.modelName).sqlite"
    
    // URL Documents Directory
    let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    // URL Persistent Store
    let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
    
    do {
      let options = [
                      NSMigratePersistentStoresAutomaticallyOption: true,
                      NSInferMappingModelAutomaticallyOption: true
                    ]
      
      // Add Persistent Store
      try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                        configurationName: nil,
                                                        at: persistentStoreURL,
                                                        options: options)
      
    } catch {
      fatalError("Unable to Add Persistent Store")
    }
    
    return persistentStoreCoordinator
  }()
  
  // MARK: - Initialization
  init(modelName: String) {
    self.modelName = modelName
    
    setupNotificationHandling()
  }
  
  // MARK: - Helper Methods
  private func setupNotificationHandling() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self,
                                   selector: #selector(saveChanges(_:)),
                                   name: Notification.Name.UIApplicationWillTerminate,
                                   object: nil)
    notificationCenter.addObserver(self,
                                   selector: #selector(saveChanges(_:)),
                                   name: Notification.Name.UIApplicationDidEnterBackground,
                                   object: nil)
  }
  
  // MARK: -
  @objc private func saveChanges(_ notification: Notification) {
    guard managedObjectContext.hasChanges else { return }
    
    do {
      try managedObjectContext.save()
    } catch {
      print("Unable to Save Managed Object Context")
      print("\(error), \(error.localizedDescription)")
    }
    
  }
}
