//
//  InterestingPhotoDataSource.swift
//  Pictogram
//
//  Created by Vo Huy on 5/28/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class InterestingPhotoDataSource: NSObject {
    
    let identifier = "InterestingCollectionViewCell"
    var photos = [Photo]()
}

// MARK: - UICollectionViewDataSource
extension InterestingPhotoDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell
        let photo = photos[indexPath.row]
        cell.photoDescription = photo.title
        return cell
    }
}
