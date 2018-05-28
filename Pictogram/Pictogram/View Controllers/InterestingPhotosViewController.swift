//
//  InterestingPhotosViewController.swift
//  Pictogram
//
//  Created by Vo Huy on 5/23/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class InterestingPhotosViewController: UIViewController {
    
    // MARK: - Properties
    var photoStore: PhotoStore!
    let interestingDataSource = InterestingPhotoDataSource()
    // MARK: Outlets
    @IBOutlet var interestingCollectionView: UICollectionView!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interestingCollectionView.dataSource = interestingDataSource
        interestingCollectionView.delegate = self
        // kick off the web service
        photoStore.fetchInterestingPhotos {
            (photosResult) -> Void in
            
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos.")
                self.interestingDataSource.photos = photos
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
                self.interestingDataSource.photos.removeAll()
            }
            self.interestingCollectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    
    // MARK: - Private methods

}

extension InterestingPhotosViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = interestingDataSource.photos[indexPath.row]
        
        // Download the image data, which could take some time
        photoStore.fetchImage(for: photo) {
            (result) in
            
            // The index path for the photo might have been changed between the
            // time the request started and finished, so find the most recent
            // index path
            guard
                let photoIndex = (self.interestingDataSource.photos as [Photo]).index(of: photo),
                case let .success(image) = result else {
                    return
            }
            
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            // The request finishes, update the cell if it is still visible
            if let cell = self.interestingCollectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                cell.update(with: image)
            }
            
        }
    }
}
