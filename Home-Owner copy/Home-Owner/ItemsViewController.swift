//
//  ItemsViewController.swift
//  Home-Owner
//
//  Created by Vo Huy on 5/11/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    // MARK: Properties
    
//    var filteredItem: [[Item]] = []
    // An array of items
    var itemStore: ItemStore!
//    {
//        didSet {
//            filteredItem = itemStore.filterItems()
//        }
//    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        // set the table view away from the status bar
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        // Set row's height. tableView should compute its cell's hights based on constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    // MARK: Actions
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        // If you are currently in editing mode...
        if isEditing {
            // inform the user of the state
            sender.setTitle("Edit", for: .normal)
            
            // Turn off editing mode
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            // Enter editing mode
            setEditing(true, animated: true)
        }
    }
    
    @IBAction func addNewItem(_ sender: UIButton) {
        // Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        // Getting the last row
        let lastRow = itemStore.allItems.index(of: newItem)
        let indexPath = IndexPath(row: lastRow!, section: 0)
        
        // Insert a new item into the last row
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: for UITableView
    
    // Calculating the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemStore.allItems.count
    }
    
    // the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "Worth more than $50"
//        case 1:
//            return "Worth less than $50"
//        default:
//            return ""
//        }
//    }
    
    // Set different Height for the footer
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
    }

    // nth row displays nth entry
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled ItemCell (check from the pool)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell

        // get the item at the row from item store
        let item = itemStore.allItems[indexPath.row]
        
        // Set the text on the cell with the description of the item
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.serialNumberLabel.font = UIFont.systemFont(ofSize: 20)
        let value = item.valueInDollars
//        if value < 50 {
//            cell.valueLabel.textColor = UIColor.green
//        } else {
//
//        }
        cell.valueLabel.textColor = value < 50 ? UIColor.green : UIColor.red
        cell.valueLabel.text = "$\(value)"
        cell.valueLabel.font = UIFont.systemFont(ofSize: 20)
        cell.backgroundColor = UIColor.clear
        // return the cell to UITableView
        return cell
    }
    
    // change the delete button's tittle
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove";
    }
    
    // called after a row being editted
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {    // the row is being deleted
            let item = itemStore.allItems[indexPath.row]
            
            // Creating an alert to warn the user
            let title = "Delete \(item.name)"
            let message = "Are you sure you want to delete this item?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            // Adding alert actions to alert controller
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                // Remove the item from the store
                self.itemStore.removeItem(item)
                
                // remove the row from the table view
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            
            // Present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }
    
    // called after a row is being moved
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    // change the footer
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "No more items!"
    }
}
