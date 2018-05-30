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
        
        // load whatever the app has loaded currently
        self.updateDataSource()
        
        // Kick off the web service
        photoStore.fetchRecentPhotos() {
            (photosResult) in
            self.updateDataSource()
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showRecentImage"?:
            if let selectedIndexPath = recentCollectionView.indexPathsForSelectedItems?.first {
                let photo = recentDataSource.photos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = photoStore
            }
        default:
            print("Unexpected segue identifier")
        }
    }
    
    // MARK: - Private methods
    private func updateDataSource() {
        photoStore.fetchAllPhotos{
            (photosResult) in
            switch photosResult {
            case let .success(photos):
                self.recentDataSource.photos = photos
            case .failure:
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

// The UI
extension RecentPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = recentCollectionView.bounds.size.width
        let numberOfItemsPerRow: CGFloat = 4
        let itemWidth = collectionViewWidth / numberOfItemsPerRow
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        recentCollectionView.reloadData()
    }
}
