//
//  CardViewModel.swift
//  Match App
//
//  Created by Huy Vo on 1/1/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import Foundation

class CardViewModel {
    
    private let card: Card
    
    init(card: Card) {
        self.card = card
    }
    
    public var isFlipped: Bool {
        return card.isFlipped
    }
    
    public var imageName: String {
        return "card\(card.imageNumber)"
    }
    
    public func flipCard() {
        card.isFlipped = !card.isFlipped
    }
    
}
