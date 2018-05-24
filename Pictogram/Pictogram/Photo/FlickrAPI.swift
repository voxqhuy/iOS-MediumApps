//
//  FlickrAPI.swift
//  Pictogram
//
//  Created by Vo Huy on 5/23/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import Foundation

enum FlickrError: Error {
    case invalidJSONData
}

enum Method: String {
    case interestingPhotos = "flickr.interestingness.getList"
}
struct FlickrAPI {
    
    // MAKR: - Properties
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    static var interestingPhtosURL: URL {
        return flickrURL(method: .interestingPhotos, paramenters: ["extras": "url_h, date_taken"])
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
    static func photos(fromJSON data: Data) -> PhotosResult {
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
                if let photo = photo(fromJSON: photoJSON) {
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
    private static func photo(fromJSON json: [String: Any]) -> Photo? {
        guard
            
            let title = json["title"] as? String,
            let photoURLString = json["url_h"] as? String,
            let remoteURL = URL(string: photoURLString),
            let photoID = json["id"] as? String,
            let dateString = json["datetaken"] as? String,
            let dateTaken = dateFormatter.date(from: dateString) else {
            // Dont have enough info to construct a photo
            return nil
        }
        return Photo(title: title, remoteURL: remoteURL, photoID: photoID, dateTaken: dateTaken)
    }
}
