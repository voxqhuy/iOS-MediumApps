//
//  RecentPhotosViewController.swift
//  Pictogram
//
//  Created by Vo Huy on 5/25/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class RecentPhotosViewController: UIViewController {
    
    // MARK: - Properties
    var photoStore: PhotoStore!
    let recentDataSource = RecentPhotoDataSource()
    // MARK: Outlets
    @IBOutlet var recentCollectionView: UICollectionView!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recentCollectionView.dataSource = recentDataSource
        recentCollectionView.delegate = self
        
        // Kick off the web service
        photoStore.fetchRecentPhotos() {
            (photosResult) in
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos.")
                self.recentDataSource.photos = photos
            case let .failure(error):
                print("Error fetching recent photos: \(error)")
                self.recentDataSource.photos.removeAll()
            }
            self.recentCollectionView.reloadSections(IndexSet(integer: 0))
        }
    }
}

extension RecentPhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = recentDataSource.photos[indexPath.row]
        
        photoStore.fetchImage(for: photo) {
            (result) in
            
            // The index path for the photo might have been changed between
            // the time request started and finished, just find the most recent
            // index path
            guard let photoIndex = self.recentDataSource.photos.index(of: photo),
                case let .success(image) = result else {
                    return
            }
            
            // The request finishes, update the cell if it is still visible
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            if let cell = self.recentCollectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                cell.update(with: image)
            }
        }
    }
}
