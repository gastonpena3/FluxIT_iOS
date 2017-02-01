//
//  AllCategories.swift
//  FluxIT
//
//  Created by Gastón Pena on 28/1/17.
//  Copyright © 2017 Gastón Pena. All rights reserved.
//

import UIKit

class AllCategories {
    var _id:Int!
    var _getDetails:String!
    var _name:String!
    var _description:String!
    
    var id:Int {
        if _id == nil {
            _id = 0
        }
    return _id
    }
    
    var getDetails:String {
        if _getDetails == nil {
            _getDetails = ""
        }
    return _getDetails
    }
    
    var name:String {
        if _name == nil {
            _name = ""
        }
    return _name
    }
    
    var description:String {
        if _description == nil {
            _description = ""
        }
        return _description
    }

    func getAllCategories(completed: DownLoadCompleted) {
        
        var request = URLRequest(url: URL(string:CURRENT_URL_ALL_CATEGORIES)!)
        request.httpMethod = "POST"
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            print("Entered the completionHandler")
            print(response)
            }.resume()
        
    }
}
