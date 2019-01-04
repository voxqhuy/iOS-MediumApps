//
//  DataService.swift
//  Match App
//
//  Created by Huy Vo on 1/1/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import Foundation

class DataService {
    static func getCards() -> [Card] {
        
        var cardsBank = [Card]()
        
        for _ in 1...8 {
            
            let randomNumber = arc4random_uniform(13) + 1
            
            let cardOne = Card(ofNumber: Int(randomNumber))
            
            let cardTwo = Card(ofNumber: Int(randomNumber))
            
            cardsBank.append(cardOne)
            cardsBank.append(cardTwo)
        }
        
        return cardsBank
    }
}
