//
//  TagDataSource.swift
//  Pictogram
//
//  Created by Vo Huy on 5/30/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
import CoreData

class TagDataSource: NSObject {
    var tags: [Tag] = []
}

extension TagDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let tag = tags[indexPath.row]
        cell.textLabel?.text = tag.name
        
        return cell
    }
}
