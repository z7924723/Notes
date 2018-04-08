//
//  ViewController.swift
//  Notes
//
//  Created by PinguMac on 2018/4/3.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
  
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Segues
  private enum Segue {
    static let AddNote = "AddNote"
    static let Note = "Note"
  }
  
  // MARK: -
  var notes: [Note]? {
    didSet {
      updateView()
    }
  }
  
  // MARK: -
  private lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
    // Create Fetch Request
    let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
    
    // Configure Fetch Request
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)]
    
    // Create Fetched Result Controller
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: self.coreDataManager.managedObjectContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
    
    // Configure Fetched Results Controller
    fetchedResultsController.delegate = self
    
    return fetchedResultsController
  }()
  
  // MARK: -
  private var hasNotes: Bool {
    guard let fetchObjects = fetchedResultsController.fetchedObjects else {
      return false
    }
    
    return fetchObjects.count > 0
  }
  
  // MARK: - Properties
  private var coreDataManager = CoreDataManager(modelName: "Notes")
  
  // MARK: -
  private let estimatedRowHeight = CGFloat(44.0)
  
  // MARK: -
  private lazy var updatedAtDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, HH:mm"
    return dateFormatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Notes"
    
    setupView()
    
    fetchNotes()
    
    updateView()
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    
    switch identifier {
    case Segue.AddNote:
      guard let destination = segue.destination as? AddNoteViewController else {
        return
      }
      
      // Configure Destination
      destination.managedObjectContext = coreDataManager.managedObjectContext
      
    case Segue.Note:
      guard let destination = segue.destination as? NoteViewController else {
        return
      }
      
      guard let indexPath = tableView.indexPathForSelectedRow else {
        return
      }
      
      // Fetch note
      let note = fetchedResultsController.object(at: indexPath)
      
      // Configure Destination
      destination.note = note
      
    default:
      break
    }
  }
  
  // MARK: - View Methods
  private func setupView() {
    setupMessageLabel()
    setupTableView()
  }
  
  private func updateView() {
    tableView.isHidden = !hasNotes
    messageLabel.isHidden = hasNotes
  }
  
  // MARK: -
  private func setupMessageLabel() {
    messageLabel.text = "You don't have any notes yet."
  }
  
  // MARK: -
  private func setupTableView() {
    tableView.isHidden = true
    tableView.estimatedRowHeight = estimatedRowHeight
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  // MARK: - Helper Methods
  private func fetchNotes() {
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print("Unable to Perform Fetch Request")
      print("\(error), \(error.localizedDescription)")
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension NotesViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = fetchedResultsController.sections?[section] else {
      return 0
    }
    return section.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Fetch Note
    let note = fetchedResultsController.object(at: indexPath)
    
    // Dequeue Reusable Cell
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
      fatalError("Unexpected Index Path")
    }
    
    // Configure Cell
    cell.titleLabel.text = note.title
    cell.contentsLabel.text = note.contents
    cell.updatedAtLabel.text = updatedAtDateFormatter.string(from: note.updatedAtAsDate)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else {
      return
    }
    
    // Fetch Note
    let note = fetchedResultsController.object(at: indexPath)
    
    // Delete Note
    coreDataManager.managedObjectContext.delete(note)
  }
}

extension NotesViewController: NSFetchedResultsControllerDelegate {

}
