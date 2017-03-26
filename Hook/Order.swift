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
    
    var menus: [Menu] = []
 
    var queue: Int = -1
    var time: Int = 1
    
    init() {
        
    }
    
    init(customerId: Int, storeId: Int, date: String) {
        self.customerId = customerId
        self.storeId = storeId
        self.date = date
    }
    
    func AddMenu(menu: Menu) {
        let isDuplicated = menus.contains { item in
            return item.id == menu.id
        }
        
        if (!isDuplicated) {
            self.menus.append(menu)
        }
        else {
            let index = self.menus.index{ item in
                return item.id == menu.id
            }
            
            self.menus[index!].count += 1
        }
    }
    
    func GetMenuListID() -> [Int] {
        var menuListID: [Int] = []
        if let menusArray = menus as NSArray as? [Menu] {
            for menu in menusArray {
                menuListID.append(menu.id)
            }
        }
        return menuListID
    }
    
    func SetMenus(menus: NSMutableArray) {
        if let menusArray = menus as NSArray as? [Menu] {
            for menu in menusArray {
                self.menus.append(menu)
            }
        }
        else {
            print("Cant set menus")
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
            "MenuList" : GetMenuListID()
        ]
        return param
    }
    
    func GetSumPrice() -> Int {
        var sum = 0
        for menu in menus {
            sum += menu.GetTotalPrice()
        }
        return sum
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
