//
//  FlickrAPI.swift
//  Pictogram
//
//  Created by Vo Huy on 5/23/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import Foundation
import CoreData

enum FlickrError: Error {
    case invalidJSONData
}

enum Method: String {
    case interestingPhotos = "flickr.interestingness.getList"
    case recentPhotos = "flickr.photos.getRecent"
}
struct FlickrAPI {
    
    // MAKR: - Properties
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    static var interestingPhotosURL: URL {
        return flickrURL(method: .interestingPhotos, paramenters: ["extras": "url_h, date_taken"])
    }
    static var recentPhotosURL: URL {
        return flickrURL(method: .recentPhotos, paramenters: ["extras": "url_h, date_taken"])
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    // a method that builds up the URL for a specific endpoint
    private static func flickrURL(method: Method, paramenters: [String:String]?) -> URL {
        
        var components = URLComponents(string: baseURLString)!
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
            ]
        
        // add base params
        for (key, val) in baseParams {
            let item = URLQueryItem(name: key, value: val)
            queryItems.append(item)
        }
        
        // add extra params
        if let additionalParams = paramenters {
            for (key, val) in additionalParams {
                let item = URLQueryItem(name: key, value: val)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.url!
    }
    
    // a method that convert the data into the basic objects
    static func photos(fromJSON data: Data, into context: NSManagedObjectContext) -> PhotosResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let photos = jsonDictionary["photos"] as? [String:Any],
                let photosArray = photos["photo"] as? [[String:Any]] else {
                    // The JSON Structure doesn't match our expectations
                    return .failure(FlickrError.invalidJSONData)
            }
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photo(fromJSON: photoJSON, into: context) {
                    finalPhotos.append(photo)
                }
            }
            
            // Check the final photos
            if finalPhotos.isEmpty && !photosArray.isEmpty {
                // We weren't able to parse any of the photos
                // Maybe the JSON format for photos has changed
                return .failure(FlickrError.invalidJSONData)
            }
            return .success(finalPhotos)
            
        } catch let error {
            return .failure(error)
        }
    }
    
    // parse a JSON dictionary into Photo instance
    private static func photo(fromJSON json: [String: Any],
                              into context: NSManagedObjectContext) -> Photo? {
        guard
            
            let title = json["title"] as? String,
            let photoURLString = json["url_h"] as? String,
            let remoteURL = URL(string: photoURLString),
            let photoID = json["id"] as? String,
            let dateString = json["datetaken"] as? String,
            let dateTaken = dateFormatter.date(from: dateString)
            else {
            // Dont have enough info to construct a photo
            return nil
        }
        
        // check whether there is an existing photo with a given ID before
        // inserting a new one
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "\(#keyPath(Photo.photoID)) == \(photoID)")
        fetchRequest.predicate = predicate
        var fetchedPhotos: [Photo]?
        context.performAndWait {
            fetchedPhotos = try? fetchRequest.execute()
        }
        if let existingPhoto = fetchedPhotos?.first {
            return existingPhoto
        }
        
        // use context to insert new photo into the context
        var photo: Photo!
        // Synchronously performs a given block on the context's queue
        context.performAndWait {
            photo = Photo(context: context)
            photo.title = title
            photo.photoID = photoID
            photo.remoteURL = remoteURL as NSURL
            photo.dateTaken = dateTaken as NSDate
        }
        return photo
    }
}
