//
//  ItemsViewController.swift
//  Home-Owner
//
//  Created by Vo Huy on 5/11/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController, UITextFieldDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // navigationItem: the view controller when it is pushed onto the controller
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // MARK: Properties
    // An array of items
    var itemStore: ItemStore!
    
    // a formatter for money
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        // Alwasys have 2 digits after the decimal point
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set row's height. tableView should compute its cell's hights based on constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is "ShowItem" segue
        switch segue.identifier {
        case "showItem"?:
            // Figure which row was tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
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
        if section == 1 {   // "No more items!"
            return 1
        } else {
            return itemStore.allItems.count
        }
    }
    
    // the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
        if indexPath.section == 1 {
            return 48
        } else {
            return 60
        }
    }

    // nth row displays nth entry
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 { // "No more items!"
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.detailTextLabel?.text = "No more items!"
            return cell
        } else {
            // Get a new or recycled ItemCell (check from the pool)
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
            
            // get the item at the row from item store
            let item = itemStore.allItems[indexPath.row]
            
            // Set the text on the cell with the description of the item
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.serialNumberLabel.font = UIFont.systemFont(ofSize: 20)
            let value = item.valueInDollars
            cell.valueLabel.textColor = value < 50 ? UIColor.green : UIColor.red
//            valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
            cell.valueLabel.text = numberFormatter.string(from: NSNumber(value: value))
            cell.valueLabel.font = UIFont.systemFont(ofSize: 20)
            cell.backgroundColor = UIColor.clear
            // return the cell to UITableView
            return cell
        }
    }
    
    // change the delete button's tittle
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove";
    }
    
    // set the editing style (prevent "No more items!" from being deleted
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 1 {
            return .none
        } else {
            return .delete
        }
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
    
    
//    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
//        if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
//            return sourceIndexPath
//        }
//        return proposedDestinationIndexPath
//    }
    
    // prevent moving to different sections
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return false
        } else {
            return true
        }
    }
    // called after a row is being moved
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}
