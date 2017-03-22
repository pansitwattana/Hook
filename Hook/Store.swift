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

class Store {
    var name: String = "not assigned"
    var address: String = "not assigned"
    var img: UIImage!
    var detail: String = "detail"
    var open: Bool = false
    var ownerId: Int = -1
    var coordinates: (latitude: Double, longitude: Double) = (1.2, 2.2)
    init(name: String) {
        self.name = name
    }
    
    init(name: String, json: JSON) {
        
        self.name = name
        
        if let address = json["Address"].string {
            self.address = address
        }
        
        if let imgUrl = json["Img"].url {
            let imageData = NSData(contentsOf: imgUrl)
            self.img = UIImage(data: imageData as! Data)
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
        
        if let id = json["Owner_ID"].int {
            self.ownerId = id
        }
    }
    
}
