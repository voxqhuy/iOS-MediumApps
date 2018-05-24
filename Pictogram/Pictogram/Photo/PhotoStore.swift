//
//  PhotoStore.swift
//  Pictogram
//
//  Created by Vo Huy on 5/24/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import Foundation

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
 
    // URLSession acts as a factory for URLSessionTask instances
    private let session: URLSession = {
        // a default session configuration object
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // @escaping = the closure might not get called immediately within the method
    // this case it will call it when the web service request completes
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        // an url instance
        let url = FlickrAPI.interestingPhtosURL
        // instantiate a request object with it
        let request = URLRequest(url: url)
        // a task that retrieves the content of an url, given a request
        let task = session.dataTask(with: request) {
            // a completion closure to call when the request finishes
            (data, response, error) -> Void in
            
            let result = self.processPhotosRequest(data: data, error: error)
            completion(result)
        }
        // tasks are always created in the suspended state, calling resume() will start the webservice request
        task.resume()
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else { return .failure(error!) }
        return FlickrAPI.photos(fromJSON: jsonData)
    }
}
