//
//  Item.swift
//  Home-Owner
//
//  Created by Vo Huy on 5/11/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
// conform to NSCoding for archiving purpose
class Item: NSObject, NSCoding {
    var name: String
    var valueInDollars: Double
    var serialNumber: String?
    var dateCreated: Date
    var textColor: UIColor
    // key in the cache
    let itemKey: String
    
    // designated initializer is required
    // this lose the free initializer init(). the free init() is usefull when all properties
    // have default values
    // designated initializer must call a designated initializer on its superclass
    init(name: String, valueInDollars: Double, serialNumber: String?) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
        self.textColor = valueInDollars > 50.0 ? UIColor.red : UIColor.green
        self.itemKey = UUID().uuidString
        
        super.init()
    }
    
    // convenience initializers are optional
    // Convenience initializer must call another initializer on the same type
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]
            
            var idx = arc4random_uniform(UInt32(adjectives.count))
            let randomAdj = adjectives[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdj) \(randomNoun)"
            let randomVal = Double(arc4random_uniform(100))
            let randomSerialNumber = UUID().uuidString.components(separatedBy: "-").first!
            
            self.init(name: randomName,
                      valueInDollars: randomVal,
                      serialNumber: randomSerialNumber
                      )
        } else {
            self.init(name: "", valueInDollars: 0, serialNumber: nil)
        }
    }
    
    // encode all names and all properties
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(dateCreated, forKey: "dateCreated")
        aCoder.encode(itemKey, forKey: "itemKey")
        aCoder.encode(serialNumber, forKey: "serialNumber")
        aCoder.encode(valueInDollars, forKey: "valueInDollars")
        aCoder.encode(textColor, forKey: "textColor")
    }
    
    // decode
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as! Date
        itemKey = aDecoder.decodeObject(forKey: "itemKey") as! String
        serialNumber = aDecoder.decodeObject(forKey: "serialNumber") as! String?
        valueInDollars = aDecoder.decodeDouble(forKey: "valueInDollars")
        textColor = aDecoder.decodeObject(forKey: "textColor") as! UIColor
        
        super.init()
    }
}
