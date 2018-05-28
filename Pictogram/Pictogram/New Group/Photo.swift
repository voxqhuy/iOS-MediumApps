//
//  Photo.swift
//  Pictogram
//
//  Created by Vo Huy on 5/24/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import Foundation

class Photo {
    
    let title: String
    let remoteURL: URL
    let photoID: String
    let dateTaken: Date
    
    init(title: String, remoteURL: URL, photoID:  String, dateTaken: Date) {
        self.title = title
        self.remoteURL = remoteURL
        self.photoID = photoID
        self.dateTaken = dateTaken
    }
    
}

extension Photo: Equatable {
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}


