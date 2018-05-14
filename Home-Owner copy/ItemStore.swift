//
//  ItemsStore.swift
//  Home-Owner
//
//  Created by Vo Huy on 5/11/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ItemStore {
    // an array of items
    var allItems = [Item]()
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }
    
    // for removing an item
    func removeItem(_ item: Item) {
        if let index = allItems.index(of: item) {
            allItems.remove(at: index)
        }
    }
    
    // for moving an item
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        // make a copy of the item being moved
        let copy = allItems[fromIndex]
        // remove the item
        allItems.remove(at: fromIndex)
        // insert item at a new location
        allItems.insert(copy, at: toIndex)
    }
    // filter items
//    func filterItems() -> [[Item]] {
//        var filterItems = [[Item](), [Item]()]
//        for item in allItems {
//            if item.valueInDollars >= 50 {
//                filterItems[0].append(item)
//            } else {
//                filterItems[1].append(item)
//            }
//        }
//        return filterItems
//    }
}
