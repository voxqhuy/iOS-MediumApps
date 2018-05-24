//
//  PhotosViewController.swift
//  Pictogram
//
//  Created by Vo Huy on 5/23/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    // MARK: - Properties
    // MARK: Outlets
    @IBOutlet var imageView: UIImageView!
    var photoStore: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // kick off the web service
        photoStore.fetchInterestingPhotos {
            (photosResult) -> Void in
            
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos.")
                if let firstPhoto = photos.first {
                    self.updateImageView(for: firstPhoto)
                }
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Private methods
    func updateImageView(for photo: Photo) {
        photoStore.fetchImage(for: photo) {
            (imageResult) -> Void in
            
            switch imageResult {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        }
    }
}
