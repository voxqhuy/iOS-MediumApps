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
