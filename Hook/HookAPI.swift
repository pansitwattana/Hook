//
//  HookAPI.swift
//  Hook
//
//  Created by Pansit Wattana on 3/12/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class HookAPI {
    let URL = "http://jqhook.azurewebsites.net/"

    func parseStore(JSONData : Data, stores: NSMutableArray){
        let jsonData = JSON(JSONData)
        if jsonData != JSON.null{
            for (name, storeJson):(String, JSON) in jsonData {
                let store = Store(name: name)
                
                if let address = storeJson["Address"].string {
                    store.address = address
                }
                
                if let imgUrl = storeJson["Img"].url {
                    let imageData = NSData(contentsOf: imgUrl)
                    store.img = UIImage(data: imageData as! Data)
                }
                
                if let location = storeJson["Location"].dictionary {
                    if let lat = location["Lat"]?.double {
                        if let long = location["Long"]?.double {
                            store.coordinates = (lat, long)
                        }
                    }
                }
                
                if let open = storeJson["Open"].bool {
                    store.open = open
                }
                
                if let id = storeJson["Owner_ID"].int {
                    store.ownerId = id
                }
                
                
                
                print(stores.count)
                stores.add(store)
            }
        }
        else {
            print("Error: Connection is lost")
        }
    }
    /*
    func GetJSON() -> JSON {
        // Do any additional setup after loading the view, typically from a nib.
        let requestURL: NSURL = NSURL(string: url)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                if data != nil {
                    self.json = JSON(data: data!)
                    print("Load succeed")
                }
            }
            else {
                print("Connection Err: " + String(statusCode))
            }
        }
        task.resume()
        return json
    }*/
}
