//
//  Store.swift
//  Hook
//
//  Created by Pansit Wattana on 3/9/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import Foundation
import UIKit

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
        
        /*
        if let name = json["Name"].string {
            self.name = name
        }
        
        if let img = json["Img"].string {
            self.img = img
        }
        
        if let detail = json["Detail"].string {
            self.detail = detail
        }
        
        if let open = json["Open"].bool {
            self.open = open
        }
        
        if let lat = json["Location"]["Lat"].double {
            if let long = json["Location"]["Long"].double {
                self.coordinates = (lat, long)
            }
        }*/
    }
    
    
}
