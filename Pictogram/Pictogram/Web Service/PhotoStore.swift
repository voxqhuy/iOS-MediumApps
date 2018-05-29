//
//  PhotoStore.swift
//  Pictogram
//
//  Created by Vo Huy on 5/24/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
import CoreData

// the result of downloading the image
enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

// photo errors
enum PhotoError: Error {
    case imageCreationError
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    
    let imageStore = ImageStore()
    
    let persistentContainer: NSPersistentContainer = {
        // name must match the data model file's name
        let container = NSPersistentContainer(name: "Pictogram")
        container.loadPersistentStores {
            // due to the possibility of this operation taking sometime
            // loading the persistent stores is an asynchronous operation
            // that calls a completion handler when complete
            (description, error) in
            if let error = error {
                print("Error setting up Core Data \(error)")
            }
        }
        return container
    } ()
    
}

// Process photo data
extension PhotoStore {
    
    // @escaping = the closure might not get called immediately within the method
    // this case it will call it when the web service request completes
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {

        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        // a task that retrieves the content of an url, given a request
        URLSession.shared.dataTask(with: request) {
            // a completion closure to call when the request finishes
            (data, response, error) in
            
            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }.resume()
        // tasks are always created in the suspended state, calling resume() will start the webservice request
    }
    
    func fetchRecentPhotos(completion: @escaping (PhotosResult) -> Void) {
        
        let url = FlickrAPI.recentPhotosURL
        let request = URLRequest(url: url)
        // a task that retrieves the content of an url, given a request
        URLSession.shared.dataTask(with: request) {
            // a completion closure to call when the request finishes
            (data, response, error) in
            
            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
            }.resume()
        // tasks are always created in the suspended state, calling resume() will start the webservice request
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else { return .failure(error!) }
        return FlickrAPI.photos(fromJSON: jsonData, into: persistentContainer.viewContext)
    }
}

// Process image data
extension PhotoStore {
    // download image data
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        
        guard let photoKey = photo.photoID else {
            preconditionFailure("Photo expected to have a photoID.")
        }
        // Check if it is in the cache
        if let image = imageStore.getImage(forKey: photoKey) {
            // The main thread
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        guard let photoURL = photo.remoteURL else {
            preconditionFailure("Photo expected to have a remote URL")
        }
        let request = URLRequest(url: photoURL as URL)
        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                print("Headers: \(httpResponse.allHeaderFields) -- ")
            }
            
            let result = self.processImageRequest(data: data, error: error)
            
            // if the image is valid, save it to the filesystem
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            
            // the main thread
            OperationQueue.main.addOperation {
                completion(result)
            }
        }.resume()
    }
    
    // process data from the web service request into image
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard
            let imageData = data,
            let image = UIImage(data: imageData)
        else {
            // Couldn't create an image
            if data == nil {
                return .failure(error!)
            } else { return .failure(PhotoError.imageCreationError) }
        }
        
        // all passed, success
        return .success(image)
    }
}
