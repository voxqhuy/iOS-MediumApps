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
        
        updateDataSource()
        // kick off the web service
        photoStore.fetchInterestingPhotos {
            (photosResult) -> Void in
            
            self.updateDataSource()
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showInterestingImage"?:
            if let selectedIndexPath = interestingCollectionView.indexPathsForSelectedItems?.first {
                let photo = interestingDataSource.photos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = photoStore
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    
    // MARK: - Private methods
    
    private func updateDataSource() {
        photoStore.fetchAllPhotos {
            (photosResult) in
            switch photosResult {
            case let .success(photos):
                self.interestingDataSource.photos = photos
            case .failure:
                self.interestingDataSource.photos.removeAll()
            }
            self.interestingCollectionView.reloadSections(IndexSet(integer: 0))
        }
    }

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

// The UI
extension InterestingPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = interestingCollectionView.bounds.size.width
        let numberOfItemsPerRow: CGFloat = 4
        let itemWidth = collectionViewWidth / numberOfItemsPerRow
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        interestingCollectionView.reloadData()
    }
}


