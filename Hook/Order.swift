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

enum OrderStatus : Int {
    case Wait
    case Done
    case Cancel
}

class Order {
    var comment: String = "-"
    var customerId: String = ""
    var user = User()
    var id: Int = -1
    var storeId: Int = -1
    var type: String = "Undone"
    
    var menus: [Menu] = []
 
    var queue: Int = -1
    var time: Int = 1
    
    var status: OrderStatus = .Wait
    
    init() {
        
    }
    
    func setUser(customerUser: User, storeId: Int) {
        self.user = customerUser
        self.storeId = storeId
    }
    
    func AddMenu(menu: Menu) {
        let isDuplicated = menus.contains { item in
            return item.id == menu.id
        }
        
        if (!isDuplicated) {
            menu.count += 1
            self.menus.append(menu)
        }
        else {
            let index = self.menus.index{ item in
                return item.id == menu.id
            }
            
            self.menus[index!].count += 1
        }
    }
    
    func RemoveMenu(menu: Menu) {
        
        let index = self.menus.index{ item in
            return item.id == menu.id
        }
        
        if index != nil {
            self.menus.remove(at: index!)
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
    
    func Set(id: Int, queue: Int, time: Int, status: OrderStatus) {
        self.id = id
        self.queue = queue
        self.time = time
        self.status = status
    }

    func GetParam() -> Parameters {
        let param: Parameters = [
            "Comment" : comment,
            "Name" : user.name,
            "LastName": user.lastName,
            "Date" : "0",
            "ID" : id,
            "Store_ID" : storeId,
            "Status" : status.rawValue,
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
    
    func SetQueue(json: JSON) {
        let queue = json
        if queue != JSON.null {
            if let id = queue["ID"].int,
                let time = queue["Time"].int,
                let queueNo = queue["Queue"].int,
                let status = queue["Status"].int
            {
                if status < 3 && status >= 0 {
                    Set(id: id, queue: queueNo, time: time, status: OrderStatus(rawValue: status)!)
                }
                else {
                    print("status code is incorrect \(status)")
                }
            }
                
               
            else {
                
                print("Can't Set Queue")
            }
        }
    }
    
    func IsDone() -> Bool {
        return queue == 0 || status == OrderStatus.Done
    }
}


//let order: Parameters = [
//    "Comment" : "ok",
//    "Name" : 1,
//    "Data" : "22",
//    "ID" : 1,
//    "Store_ID" : 1,
//    "Type" : "Undone",
//    "MenuList" : [
//        0, 1
//    ]
//]
