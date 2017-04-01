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
    
    static func Login(user: String, password: String, _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
        
//        Alamofire.request(HookAPI.URL + "/login/").validate().responseJSON { (response) in
//            do {
//                let userJson = JSON(data: response.data!)
//                let error = response.error
//                completion(error as NSError?, userJson)
//            }
//        }
        
        let userParam: Parameters = [
            "username" : user,
            "password" : password,
            ]
        
        print(userParam)
        Alamofire.request("\(HookAPI.URL)login/", method: .post, parameters: userParam, encoding: JSONEncoding.default).validate().responseJSON {
            (response) in
            do {
                let json = JSON(response.data!)
                let error = response.error
                completion(error as NSError?, json)
            }
        }

    }
    
    static func getSearchJson(keyword: String, _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
//        let lowercaseKeyword = keyword.lowercased()
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
        
        print(order)    
        Alamofire.request("\(HookAPI.URL)order/add/", method: .post, parameters: order, encoding: JSONEncoding.default).validate().responseJSON {
            (response) in
            do {
                let json = JSON(response.data!)
                let error = response.error
                completion(error as NSError?, json)
            }
        }
    }
    
    static func getOrder(orderID: Int, _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
        Alamofire.request(HookAPI.URL + "order/\(orderID)/wait").validate().responseJSON { (response) in
            do {
                let orderJson = JSON(data: response.data!)
                let error = response.error
                completion(error as NSError?, orderJson)
            }
        }
    }

}
