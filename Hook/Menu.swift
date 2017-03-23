//
//  Menu.swift
//  Hook
//
//  Created by Pansit Wattana on 3/20/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Menu {
    var name: String = "no name"
    var id: Int = -1
    var price: Int = 0
    var detail: String = "detail"
    var img: UIImage!
    var catagory: String = "none"
    
    init(name: String) {
        self.name = name
    }
    
    init(id: String, json: JSON) {
        if let orderID = Int(id) {
            self.id = orderID
        }
        else {
            print("Order ID is not INTEGER \(id)")
        }
        
        if let name = json["Name"].string {
            self.name = name
        }
        
        if let catagory = json["Catagory"].string {
            self.catagory = catagory
        }
        
        if let price = json["Price"].int {
            self.price = price
        }
        
        if let imgUrl = json["Img"].url {
            let imageData = NSData(contentsOf: imgUrl)
            self.img = UIImage(data: imageData as! Data)
        }
    }
}
