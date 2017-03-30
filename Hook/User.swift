//
//  User.swift
//  Hook
//
//  Created by Pansit Wattana on 3/24/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    static var current = User(name: "Guest")
    
    var name: String = "Guest"
    var key: String = "0"
    var id: String = "HSjRqk2ClfbaKpQSGzpUgiI1gV52"
    var email: String = "unknown@hook.com"
    var lastName: String = "Unknown"
    var type: String = "Guest"
    
    init(name: String) {
        self.name = name
    }
    
    init(userJson: JSON) {
        let jsonData = userJson
        if jsonData != JSON.null{
            for (key, json):(String, JSON) in jsonData {
                self.key = key
                
                if let email = json["Email"].string {
                    self.email = email
                }
                
                if let name = json["Name"].string {
                    self.name = name
                }
                
                if let lastName = json["Lastname"].string {
                    self.lastName = lastName
                }
                
                if let type = json["Type"].string {
                    self.type = type
                }
            }
        }
        else {
            print("JSON can't parse")
        }
    }
}
