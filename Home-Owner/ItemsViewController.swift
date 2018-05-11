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
    
    // MARK: for UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    // nth row displays nth entry
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of UITableViewCell, with style 'value1' appearance
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        // get the item at the row from item store
        let item = itemStore.allItems[indexPath.row]
        
        // Set the text on the cell with the description of the item
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        // return the cell to UITableView
        return cell
    }
}
