//
//  Store.swift
//  Hook
//
//  Created by Pansit Wattana on 3/9/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

public enum SearchType {
    case Text
    case Location
    case Popular
}

class Store {
    var name: String = "not assigned"
    var id: Int = -1
    var address: String = "not assigned"
    var imgUrl: String = ""
    var imageView: UIImage!
    var doneLoadImg: Bool = false
    var detail: String = "detail"
    var open: Bool = false
    var ownerId: String = ""
    var categories: [String] = ["Food", "Drink", "Dessert", "Fruit"]
    var coordinates: (latitude: Double, longitude: Double) = (1.2, 2.2)
    init(name: String) {
        self.name = name
    }
    
    init(name: String, json: JSON) {
        
        self.name = name
        
        if json != JSON.null {
            if let address = json["Address"].string {
                self.address = address
            }
            
            if let id = json["ID"].int {
                self.id = id
            }
            
            if let imgUrl = json["Img"].string {
                self.imgUrl = imgUrl
            }
            
            if let location = json["Location"].dictionary {
                if let lat = location["Lat"]?.double {
                    if let long = location["Long"]?.double {
                        self.coordinates = (lat, long)
                    }
                }
            }
            
            if let open = json["Open"].bool {
                self.open = open
            }
            
            if let id = json["Owner_ID"].string {
                self.ownerId = id
            }
        }
    }
    
    func getDistance() -> Double {
        
        return 1.3
    }
}
