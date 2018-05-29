//
//  ImageStore.swift
//  Pictogram
//
//  Created by Vo Huy on 5/28/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ImageStore {
    
    // MARK: Properties
    // a cache (like a dictionary) keeps keys and values. It is a temporary
    // store. It removes objects if the system gets low on memory.
    let cache = NSCache<NSString, UIImage>()
    
    // MARK: Methods
    // URL for writing and reading in the "Documents" directories of the OS
    func imageURL(forKey key: String) -> URL {
        
        // userDomainMask = The user's home directory, place for personal items
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent(key)
    }
}

// manage Images (caching)
extension ImageStore {
    
    func setImage(_ image: UIImage, forKey key: String) {
        
        // Create URL for the image
        let url = imageURL(forKey: key)
        
        // Turn an image into JPEG
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            // Write it to full URL
            let _ = try? data.write(to: url, options: [.atomic])
            // "wirte is not archiving, its copying the bytes in the Data directly to the filesystem
        }
        cache.setObject(image, forKey: key as NSString)
    }
    
    func getImage(forKey key: String) -> UIImage? {
        
        // check the cache
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        // load from the filesystem
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        // also delete from the file system
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
    }
}
