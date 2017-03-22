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
        Alamofire.request(HookAPI.URL + "menu/get/\(store)").validate().responseJSON { (response) in
            do {
                let menuJson = JSON(data: response.data!)
                let error = response.error
                completion(error as NSError?, menuJson)
            }
        }
    }
}
