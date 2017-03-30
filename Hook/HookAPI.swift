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
    static let URL = "http://jqhook.azurewebsites.net/"

    static func parseStores(json : JSON, stores: NSMutableArray) {
        stores.removeAllObjects()
        let jsonData = json
        if jsonData != JSON.null{
            for (name, storeJson):(String, JSON) in jsonData {
                let store = Store(name: name, json: storeJson)
                
                print("Loaded: \(store.name)")
                stores.add(store)
            }
        }
        else {
            print("No Result")
        }
    }
    
    static func parseMenus(json : JSON, menus: NSMutableArray) {
        menus.removeAllObjects()
        let jsonData = json
        if jsonData != JSON.null {
            for (id, menuJson) : (String, JSON) in jsonData {
                let menu = Menu(id: id, json: menuJson)
                
                print("Loaded: \(menu.name) \(menu.count)")
                menus.add(menu)
            }
        }
        else {
            print("No Result")
        }
    }
}
