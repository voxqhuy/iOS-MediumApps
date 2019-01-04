//
//  ViewController.swift
//  Match App
//
//  Created by Huy Vo on 1/1/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    var viewModel = [CardViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        
        viewModel = DataService.getCards().map({return
            CardViewModel(card: $0)
        })
        cardCollectionView.reloadData()
    }
}

// MARK: -@protocol UITableViewDelegate
extension ViewController: UICollectionViewDelegate {
    
}

// MARK: -@protocol UITableViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        cell.cardViewModel = viewModel[indexPath.row]
        cell.frontImageView.image = UIImage(named: cell.cardViewModel.imageName) 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        if (cell.cardViewModel.isFlipped) {
            cell.flipBack()
        } else {
            cell.flip()
        }
        cell.cardViewModel.flipCard()
    }
    
}

