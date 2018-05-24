//
//  FlickrAPI.swift
//  Pictogram
//
//  Created by Vo Huy on 5/23/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import Foundation

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
    
    
}
