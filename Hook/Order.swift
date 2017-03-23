//
//  Order.swift
//  Hook
//
//  Created by Pansit Wattana on 3/21/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//
import SwiftyJSON
import Foundation
import Alamofire

class Order {
    var comment: String = "-"
    var customerId: Int = -1
    var date: String = "22"
    var id: Int = -1
    var storeId: Int = -1
    var type: String = "Undone"
    var menus: [Int] = []
    
    var queue: Int = -1
    var time: Int = 1
    
    init() {
        
    }
    
    init(customerId: Int, storeId: Int, date: String) {
        self.customerId = customerId
        self.storeId = storeId
        self.date = date
    }
    
    func SetMenus(menus: NSMutableArray) {
        for menu in menus as NSArray as! [Menu] {
            menus.add(menu.id)
        }
    }
    
    func Set(id: Int, queue: Int, time: Int) {
        self.id = id
        self.queue = queue
        self.time = time
    }

    func GetParam() -> Parameters {
        let param: Parameters = [
            "Comment" : comment,
            "Customer_ID" : customerId,
            "Date" : date,
            "ID" : id,
            "Store_ID" : storeId,
            "Type" : type,
            "MenuList" : menus
        ]
        return param
    }
    
    
}
//let order: Parameters = [
//    "Comment" : "ok",
//    "Customer_ID" : 1,
//    "Data" : "22",
//    "ID" : 1,
//    "Store_ID" : 1,
//    "Type" : "Undone",
//    "MenuList" : [
//        0, 1
//    ]
//]
