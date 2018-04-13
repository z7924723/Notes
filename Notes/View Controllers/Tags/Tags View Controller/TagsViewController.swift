//
//  TagsViewController.swift
//  Notes
//
//  Created by PinguMac on 2018/4/12.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit
import CoreData

class TagsViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Segues
  private enum Segue {
    static let Tag = "Tag"
    static let AddTag = "AddTag"
  }
  
  // MARK: -
  var note: Note?
  
  // MARK: -
  private lazy var fetchedResultsController: NSFetchedResultsController<Tag> =  {
    guard let managedObjectContext = self.note?.managedObjectContext else {
      fatalError("No Managed Object Context Found")
    }
    
    // Create Fetch Request
    let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
    
    // Configure Fetch Request
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Tag.name), ascending: true)]
    
    // Create Fetched Results Controller
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    
    // Configure Fetched Results Controller
    fetchedResultsController.delegate = self
    
    return fetchedResultsController
  }()
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Tags"
    
    setupView()
    
    do {
      try fetchedResultsController.performFetch()
    } catch {
      let fetchError = error as NSError
      print("Unable to Perform Fetch Request")
      print("\(fetchError), \(fetchError.localizedDescription)")
    }
    
    updateView()
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    
    switch identifier {
    case Segue.AddTag:
      guard let destination = segue.destination as? AddTagViewController else {
        return
      }
      
      // Configure Destination
      destination.managedObjectContext = note?.managedObjectContext
      
    case Segue.Tag:
      guard let destination = segue.destination as? TagViewController else {
        return
      }
      
    default:
      break
    }
  }
  
  // MARK: - View Methods
  private func setupView() {
    setupMessageLabel()
    setupBarButtonItems()
  }
  
  private func updateView() {
    var hasTags = false
    
    if let fetchedObjects = fetchedResultsController.fetchedObjects {
      hasTags = fetchedObjects.count > 0
    }
    
    tableView.isHidden = !hasTags
    messageLabel.isHidden = hasTags
  }
  
  // MARK: -
  private func setupMessageLabel() {
    // Configure Message Label
    messageLabel.text = "You don't have any tags yet."
  }
  
  // MARK: -
  private func setupBarButtonItems() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(sender:)))
  }
  
  // MARK: - Actions
  @IBAction private func add(sender: UIBarButtonItem) {
    performSegue(withIdentifier: Segue.AddTag, sender: self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

extension TagsViewController: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
    
    updateView()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch (type) {
    case .insert:
      if let indexPath = newIndexPath {
        tableView.insertRows(at: [indexPath], with: .fade)
      }
    case .delete:
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
    case .update:
      if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
        configure(cell, at: indexPath)
      }
    case .move:
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
      
      if let newIndexPath = newIndexPath {
        tableView.insertRows(at: [newIndexPath], with: .fade)
      }
    }
  }
}

extension TagsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = fetchedResultsController.sections?[section] else { return 0 }
    return section.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Dequeue Reusable Cell
    let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as UITableViewCell
    
    // Configure Cell
    configure(cell, at: indexPath)
    
    return cell
  }
  
  private func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
    // Fetch Tag
    let tag = fetchedResultsController.object(at: indexPath)
    
    cell.textLabel?.text = tag.name
    
    if let containsTag = note?.tags?.contains(tag), containsTag == true {
      cell.textLabel?.textColor = UIColor.bitterSweet
    } else {
      cell.textLabel?.textColor = UIColor.black
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    
    // Fetch Tag
    let tag = fetchedResultsController.object(at: indexPath)
    
    // Delete Tag
    note?.managedObjectContext?.delete(tag)
  }
}

extension TagsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Fetch Tag
    let tag = fetchedResultsController.object(at: indexPath)
    
    if let containsTag = note?.tags?.contains(tag), containsTag == true {
      note?.removeFromTags(tag)
    } else {
      note?.addToTags(tag)
    }
    
    // Pop View Controller
    let _ = navigationController?.popViewController(animated: true)
  }
}
