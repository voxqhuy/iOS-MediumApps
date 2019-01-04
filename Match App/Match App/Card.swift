//
//  Card.swift
//  Match App
//
//  Created by Huy Vo on 1/1/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import Foundation

class Card {
    
    var imageNumber: Int
    var isFlipped = false
    var isMatched = false
    
    init(ofNumber number: Int) {
        imageNumber = number
    }

}
