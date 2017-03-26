	//
//  Request.swift
//  Hook
//
//  Created by Pansit Wattana on 3/20/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Request {
        
    static func getSearchJson(keyword: String, _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
        Alamofire.request(HookAPI.URL + "search/\(keyword)").validate().responseJSON { (response) in
            do {
                let searchJson = JSON(data: response.data!)
                let error = response.error
                completion(error as NSError?, searchJson)
            }
        }
    }
    
    static func getSearchJson(location: (Double, Double), _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
        Alamofire.request(HookAPI.URL + "search/").validate().responseJSON { (response) in
            do {
                let searchJson = JSON(data: response.data!)
                let error = response.error
                completion(error as NSError?, searchJson)
            }
        }
    }
    
    static func getMenuJson(store: String, _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
        
        let url = HookAPI.URL + "menu/get/\(store)"
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if urlString != nil {
            Alamofire.request(urlString!).validate().responseJSON { (response) in
                do {
                    let menuJson = JSON(data: response.data!)
                    let error = response.error
                    completion(error as NSError?, menuJson)
                }
            }
        }
        else {
            print(url + " is incorrect")
        }
    }
    
    static func cancelOrder(orderID: Int, _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
        Alamofire.request(HookAPI.URL + "order/\(orderID)/cancel").validate().responseJSON { (response) in
            do {
                let orderJson = JSON(data: response.data!)
                let error = response.error
                completion(error as NSError?, orderJson)
            }
        }
    }
    
    static func postOrderJson(order: Parameters, _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
      /*   var order = Dictionary<String, Any>()
        order["Comment"] = "-"
        order["Customer_ID"] = 1
        order["Date"] = "22"
        order["ID"] = 1
        order["Store_ID"] = 1
        order["Type"] = "Undone"
        
         {
            "Comment":"ok"
            ,"Customer_ID":1
            ,"Date":"22"
            ,"ID":1
            ,"Store_ID":1
            ,"Type":"Done"
        }
        */
//        let order: Parameters = [
//            "Comment" : "ok",
//            "Customer_ID" : 1,
//            "Data" : "22",
//            "ID" : 1,
//            "Store_ID" : 1,
//            "Type" : "Undone",
//            "MenuList" : [
//                0, 1
//            ]
//        ]
//        
        
        Alamofire.request("\(HookAPI.URL)order/add/", method: .post, parameters: order, encoding: JSONEncoding.default).validate().responseJSON {
            (response) in
            do {
                let json = JSON(response.data!)
                let error = response.error
                completion(error as NSError?, json)
            }
        }
    }
}
