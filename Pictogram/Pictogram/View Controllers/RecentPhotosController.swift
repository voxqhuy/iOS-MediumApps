//
//  recentPhotosController.swift
//  Pictogram
//
//  Created by Vo Huy on 5/25/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class RecentPhotosController: UIViewController {

    // MARK: - Properties
    var photoStore: PhotoStore!
    let recentDataSource = RecentPhotoDataSource()
    // MARK: Outlets
    @IBOutlet var recentCollectionView: UICollectionView!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recentCollectionView.dataSource = recentDataSource

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

    // MARK: - Private methods
//    func updateImageView(for photo: Photo) {
//        photoStore.fetchImage(for: photo) {
//            (imageResult) in
//
//            switch imageResult {
//            case let .success(image):
//                    self.imageView.image = image
//            case let .failure(error):
//                print("Error downloading iamge: \(error)")
//            }
//        }
//    }
}
