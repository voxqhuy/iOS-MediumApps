//
//  PhotoInfoViewController.swift
//  Pictogram
//
//  Created by Vo Huy on 5/28/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

// MARK: - Properties
class PhotoInfoViewController: UIViewController {
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    // MARK: Outlet
    @IBOutlet var imageView: UIImageView!
}

// MARK: - View life cycle
extension PhotoInfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.accessibilityLabel = photo.title

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

// MARK: - Navigation
extension PhotoInfoViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showTags"?:
            let navController = segue.destination as! UINavigationController
            let tagController = navController.topViewController as! TagsTableViewController
            // pass along its photoStore and photo
            tagController.photoStore = store
            tagController.photo = photo
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}
