//
//  Model.swift
//  FluxIT
//
//  Created by Gastón Pena on 30/1/17.
//  Copyright © 2017 Gastón Pena. All rights reserved.
//

import Foundation

struct Tv {
    var name: String = ""
    var id: Int = 0
    var getDetail: String = ""
    var description: String = ""
    
    init(dictionary: [String: AnyObject]) {
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        if let id = dictionary["id"] as? Int {
            self.id = id
        }
        if let getDetail = dictionary["getDetail"] as? String {
            self.getDetail = getDetail
        }
        if let description = dictionary["description"] as? String {
            self.description = description
        }
    }
}

struct Details {
    var id: Int = 0
    var title: String = ""
    var image: String = ""
    var seasons = [[String:AnyObject]]()
    var actors = [[String:AnyObject]]()
    var getDetail:String = ""
    
    init(dictionary: [String: AnyObject]) {
        if let id = dictionary["id"] as? Int {
            self.id = id
        }
        if let title = dictionary["title"] as? String {
            self.title = title
        }
        if let image = dictionary["image"] as? String {
            self.image = image
        }
        if let seasons = dictionary["Seasons"] as? [[String : AnyObject]] {
            self.seasons = seasons
        }
        if let actors = dictionary["Actors"] as? [[String : AnyObject]] {
            self.actors = actors
        }
        if let getDetail = dictionary["getDetail"] as? String {
            self.getDetail = getDetail
        }
    }
}
