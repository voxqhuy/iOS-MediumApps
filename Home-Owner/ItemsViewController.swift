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
    // An array of items
    var itemStore: ItemStore!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        // set the table view away from the status bar
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    // MARK: for UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    // nth row displays nth entry
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell (check from the pool)
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        // get the item at the row from item store
        let item = itemStore.allItems[indexPath.row]
        
        // Set the text on the cell with the description of the item
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        // return the cell to UITableView
        return cell
    }
}
