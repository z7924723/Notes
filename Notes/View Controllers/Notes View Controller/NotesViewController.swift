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
  private var hasNotes: Bool {
    guard let notes = notes else { return false }
    return notes.count > 0
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
    
    setupNotificationHandling()
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
    
    case Segue.Note:
      guard let destination = segue.destination as? NoteViewController else {
        return
      }
      
      guard let indexPath = tableView.indexPathForSelectedRow, let note = notes?[indexPath.row] else {
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
  
  private func fetchNotes() {
    // Create Fetch Request
    let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
    
    // Configure Fetch Request
    fetchRequest.sortDescriptors = [ NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false) ]
    
    // Perform Fetch Request
    coreDataManager.managedObjectContext.performAndWait {
      do {
        // Execute Fetch Request
        let notes = try fetchRequest.execute()
        
        // Update Notes
        self.notes = notes
        
        // Reload Table View
        self.tableView.reloadData()
        
      } catch {
        let fetchError = error as NSError
        print("Unable to Execute Fetch Request")
        print("\(fetchError), \(fetchError.localizedDescription)")
      }
    }
  }
  
  // Mark: -
  private func setupNotificationHandling() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(managedObjectContextObjectsDidChange(_:)),
                                           name: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                           object: coreDataManager.managedObjectContext)
  }
  
  // MARK: - Notification Handling
  @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
    guard let userInfo = notification.userInfo else {
      return
    }
    
    // Helpers
    var notesDidChange = false
    
    if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
      for insert in inserts {
        if let note = insert as? Note {
          notes?.append(note)
          notesDidChange = true
        }
      }
    }
    
    if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
      for update in updates {
        if let _ = update as? Note {
          notesDidChange = true
        }
      }
    }
    
    if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
      for delete in deletes {
        if let note = delete as? Note {
          if let index = notes?.index(of: note) {
            notes?.remove(at: index)
            notesDidChange = true
          }
        }
      }
    }
    
    if notesDidChange {
      // Sort Notes
      notes?.sort(by: { (first, second) -> Bool in
        first.updatedAtAsDate > second.updatedAtAsDate
      })
      
      // Update Table View
      tableView.reloadData()
      
      // Update View
      updateView()
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension NotesViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let notes = notes else { return 0 }
    return notes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Fetch Note
    guard let note = notes?[indexPath.row] else {
      fatalError("Unexpected Index Path")
    }
    
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
}

