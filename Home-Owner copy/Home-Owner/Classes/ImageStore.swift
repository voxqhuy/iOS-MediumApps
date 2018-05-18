//
//  ImageStore.swift
//  Home-Owner
//
//  Created by Vo Huy on 5/17/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit    // UIImage

class ImageStore {
    
    // MARK: Properties
    // a cache (like dictionary) keeps key and value. It removes objects if the system gets
    // low on memory. Since NSCache is ojbC class, it requires NSString instead of String
    let cache = NSCache<NSString, UIImage>()
    
    
    
    // MARK: Methods
    
    // URL to write and read in the "Documents" directory
    func imageURL(forKey key: String) -> URL {
        
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
    
    // set an image
    func setImage(_ image: UIImage, forKey key: String) {
        
        // Create full URL for image
        let url = imageURL(forKey: key)
        
        // Turn image in to JPEG Data
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            // Write it to full URL
            let _ = try? data.write(to: url, options: [.atomic])
            // "write" is not archiving, its copying the bytes in the Data directly to the filesystem
        }
        cache.setObject(image, forKey: key as NSString) // cast each String to an NSString when passing it to the cache
    }
    
    // access an image
    func image(forKey key: String) -> UIImage? {
        
        // check the cache
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        // check the filesystem
        let url = imageURL(forKey: key)
        // the compiler will only continue past the guard statement if the condition within the guard is true, else the else statement exes
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        
        return imageFromDisk
    }
    
    // delete an image
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        // when an image is delete from the store, it is also deleted from the filesystem
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
    }
    
    
}
