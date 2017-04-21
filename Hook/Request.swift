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
    
    static func Home( _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
        Alamofire.request(HookAPI.URL + "homepage").validate().responseJSON { (response) in
            do {
                let json = JSON(data: response.data!)
                let error = response.error
                completion(error as NSError?, json)
            }
        }
    }

    
    static func Login(user: String, password: String, _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
        let userParam: Parameters = [
            "username" : user,
            "password" : password,
            ]
        
        print(userParam)
        Alamofire.request("\(HookAPI.URL)login/user/", method: .post, parameters: userParam, encoding: JSONEncoding.default).validate().responseJSON {
            (response) in
            do {
                let json = JSON(response.data!)
                let error = response.error
                completion(error as NSError?, json)
            }
        }

    }
    
    static func Logout(user: String,  _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
        
        let userParam: Parameters = [
            "username" : user
        ]
        
        Alamofire.request("\(HookAPI.URL)logout/", method: .post, parameters: userParam, encoding: JSONEncoding.default).validate().responseJSON {
            (response) in
            do {
                let json = JSON(response.data!)
                let error = response.error
                completion(error as NSError?, json)
            }
        }
    }
    
    static func Register(userParam: Parameters,  _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
        print("\(HookAPI.URL)register/")
        Alamofire.request("\(HookAPI.URL)signup/", method: .post, parameters: userParam, encoding: JSONEncoding.default).validate().responseJSON {
            (response) in
            do {
                let json = JSON(response.data!)
                let error = response.error
                completion(error as NSError?, json)
            }
        }
        
    }
    
    static func getSearchJson(keyword: String, _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
        
        let url = HookAPI.URL + "search/\(keyword)"
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if urlString != nil {
            Alamofire.request(urlString!).validate().responseJSON { (response) in
                do {
                    let searchJson = JSON(data: response.data!)
                    let error = response.error
                    completion(error as NSError?, searchJson)
                }
            }
        }
        else {
            print(url + " is not valid")
        }
    }
    
    static func getSearchJson(location: (Double, Double), _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
        Alamofire.request(HookAPI.URL + "browse/\(location.0),\(location.1)").validate().responseJSON { (response) in
            do {
                let searchJson = JSON(data: response.data!)
                let error = response.error
                completion(error as NSError?, searchJson)
            }
        }
    }
    
    static func postFeedback(feedback: Parameters, _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
        Alamofire.request(HookAPI.URL + "feedback/add", method: .post, parameters: feedback, encoding: JSONEncoding.default).validate().responseJSON { (response) in
            do {
                let response = JSON(data: response.data!)
                let error = response.error
                completion(error as NSError?, response)
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
        Alamofire.request("\(HookAPI.URL)order/add/", method: .post, parameters: order, encoding: JSONEncoding.default).validate().responseJSON {
            (response) in
            do {
                print(response)
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
