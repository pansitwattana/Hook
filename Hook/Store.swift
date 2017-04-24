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

public enum Category {
    case All
}

class Store {
    var name: String = "not assigned"
    var id: Int = -1
    var address: String = "feedback"
    var imgUrl: String = ""
    var imageView: UIImage!
    var doneLoadImg: Bool = false
    var thumnailUrl: String = ""
    var thumnailImageView: UIImage!
    var doneLoadThumnail: Bool = false
    var currency: String = "$"
    var detail: String = "detail"
    var tel: String = "0999999999"
    var open: Bool = false
    var ownerId: String = ""
    var openTime: String = "08.00"
    var closeTime: String = "18.00"
    var categories: [String] = ["Food", "Drink", "Dessert", "Fruit"]
    var coordinates: (latitude: Double, longitude: Double) = (1.2, 2.2)
    var rating: Double = 5
    var review: Int = 0
    var distance: Double = 0
    var queue: Int = 0
    var avgWaitTime: Double = 0
    var avgMoney: Int = 0
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
            
            if let thumnailUrl = json["Thumnail"].string {
                self.thumnailUrl = thumnailUrl
            }
            else {
                print("no thumnail key")
            }
            
            if let location = json["Location"].dictionary {
                if let lat = location["Lat"]?.double {
                    if let long = location["Long"]?.double {
                        self.coordinates = (lat, long)
                    }
                }
            }
            
            if let open = json["Status"].bool {
                self.open = open
            }
            
            if let openTime = json["Open"].string {
                self.openTime = openTime
            }
            
            if let closeTime = json["Close"].string {
                self.closeTime = closeTime
            }
            
            if let telNo = json["Tel"].string {
                self.tel = telNo
            }
            
            if let address = json["Address"].string {
                self.address = address
            }
            
            if let id = json["Owner_ID"].string {
                self.ownerId = id
            }
            
            if let distance = json["Distant"].number {
                self.distance = Double(distance)
            }
            
            if let rate = json["Rate"].double {
                self.rating = rate
            }
            
            if let review = json["Review"].int {
                self.review = review
            }
            
            if let avgMoney = json["Money"].int {
                self.avgMoney = avgMoney
            }
            
            if let orderReport = json["OrderReport"].dictionary {
                if let queue = orderReport["Queue_num"]?.int {
                    self.queue = queue
                }
                
                if let avgWaitTime = orderReport["Queue_AvgTime"]?.double {
                    self.avgWaitTime = avgWaitTime
                }
            }
//            "OrderReport": {
//                "Queue_num": 0,
//                "Queue_AvgTime": 0
//            }
//            
        }
    }
    
    func hasDistance() -> Bool {
        return distance != 0
    }
    
    func getOpenTime() -> String {
        return "\(openTime)-\(closeTime)"
    }
    
    func getDistance() -> String {
        return String(format: "%.2f", distance)
    }
    
    func getWaitTime() -> Double {
        return avgWaitTime * Double(queue+1)
    }
}
