//
//  TagsTableViewController.swift
//  Pictogram
//
//  Created by Vo Huy on 5/30/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
import CoreData

class TagsTableViewController: UITableViewController {
    
    // MARK: Properties
    var photoStore: PhotoStore!
    var photo: Photo!
    var selectedIndexPaths = [IndexPath]()
    let tagDataSource = TagDataSource()
    
    // Outlets

    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = tagDataSource
        tableView.delegate = self
        
        updateTags()
    }
    
    // MARK: Actions
    
    @IBAction func done(_ sender: Any) {
        // presentingViewController = the view controller that presented this view
        // dismiss the view that was presented modally
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewTag(_ sender: Any) {
    }
    
    
    // MARK: Private Methods
    func updateTags() {
        photoStore.fetchAllTags{
            (tagsResult) in
            switch tagsResult {
            case let .success(tags):
                self.tagDataSource.tags = tags
                // the tags of the photo
                guard let photoTags = self.photo.tags as? Set<Tag> else {
                    return
                }
                // append each tag of the photo to the selectedIndexPaths
                for tag in photoTags {
                    if let index = self.tagDataSource.tags.index(of: tag) {
                        let indexPath = IndexPath(row: index, section: 0)
                        self.selectedIndexPaths.append(indexPath)
                    }
                }
            case let .failure(error):
                print("Error fetchting tags: \(error)")
            }
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}

extension TagsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // the tag of the selected row
        let tag = tagDataSource.tags[indexPath.row]
        
        // check if the tag is already assigned to the photo
        if let index = selectedIndexPaths.index(of: indexPath) {
            // remove the selected row
            selectedIndexPaths.remove(at: index)
            // remove the selected tag from the photo
            photo.removeFromTags(tag)
        } else {
            // the tag is not assigned to the photo, assign it
            selectedIndexPaths.append(indexPath)
            photo.addToTags(tag)
        }
        
        do {
            // commit unsaved changes to the context
            try photoStore.persistentContainer.viewContext.save()
        } catch {
            print("Core Data save failed: \(error)")
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        // check if the cell is selected
        if selectedIndexPaths.index(of: indexPath) != nil {
            // the cell has a checkmark on its right side
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

