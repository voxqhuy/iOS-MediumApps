//
//  PhotoInfoViewController.swift
//  Pictogram
//
//  Created by Vo Huy on 5/28/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    // MARK: - Properties
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    // MARK: Outlet
    @IBOutlet var imageView: UIImageView!

    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        store.fetchImage(for: photo) {
            (result) in
            switch result {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
