//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by Huy Vo on 1/1/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var cardViewModel: CardViewModel!
    
    func flip() {
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack() {
        UIView.transition(from: frontImageView, to: backImageView, duration: 0.2, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
    }
    
}
