//
//  PhotoCollectionViewCell.swift
//  Pictogram
//
//  Created by Vo Huy on 5/28/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
}


extension PhotoCollectionViewCell {
    // reset each cell to the spinning state when the cell is first created
    override func awakeFromNib() {
        super.awakeFromNib()
        update(with: nil)
    }
    
    // when the cell is getting reused
    override func prepareForReuse() {
        super.prepareForReuse()
        update(with: nil)
    }
}


// MARK: - Helpers
extension PhotoCollectionViewCell {
    func update(with image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
}
