//
//  Item.swift
//  Home-Owner
//
//  Created by Vo Huy on 5/11/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class Item: NSObject {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    let dateCreated: Date
    
    // designated initializer is required
    // this lose the free initializer init(). the free init() is usefull when all properties
    // have default values
    // designated initializer must call a designated initializer on its superclass
    init(name: String, valueInDollars: Int, serialNumber: String?) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
        
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
            let randomVal = Int(arc4random_uniform(100))
            let randomSerialNumber = UUID().uuidString.components(separatedBy: "-").first!
            
            self.init(name: randomName,
                      valueInDollars: randomVal,
                      serialNumber: randomSerialNumber
                      )
        } else {
            self.init(name: "", valueInDollars: 0, serialNumber: nil)
        }
    }
}
