//
//  User.swift
//  Hook
//
//  Created by Pansit Wattana on 3/24/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class User {
    static var current = User(name: "Guest")
    
    var name: String = "Guest"
    var key: String = "0"
    var id: String = "HSjRqk2ClfbaKpQSGzpUgiI1gV52"
    var email: String = "unknown@hook.com"
    var lastName: String = "Unknown"
    var type: Int = -1
    var isOrdering: Bool = false
    
    public static func Save() {
        //UserDefaults.standard.setValue(User.current, forKey: "user_auth_token")
        //print("\(UserDefaults.standard.value(forKey: "user_auth_token")!)")
        print("User Saved")
    }
    
    public static func Load() {
        if let user = UserDefaults.standard.value(forKey: "user_auth_token") as? User {
            User.current = user
            print("User Loaded")
        }
        else {
            print(UserDefaults.standard.value(forKey: "user_auth_token") ?? "cant get User")
            print("Login as Guest")
            User.current = User()
        }
    }
    
    init(params: Parameters) {
        
    }
    
    init() {
        self.name = "Guest"
    }
    
    init(name: String) {
        self.name = name
    }
    
    init(userJson: JSON) {
        let jsonData = userJson
        if jsonData != JSON.null{
                let json = jsonData
                if let email = json["Email"].string {
                    self.email = email
                }
                else {
                    print("Cant parse email")
                }
                
                if let name = json["Name"].string {
                    self.name = name
                }
                else {
                    print ("Cant parse name")
                }
                
                if let lastName = json["Lastname"].string {
                    self.lastName = lastName
                }
                else {
                    print ("Cant parse lastname")
                }
                
                if let type = json["Type"].int {
                    self.type = type
                }
                else {
                    print("Cant parse type")
                }
        }
        else {
            print("JSON can't parse")
        }
    }
    
    public func isLogin() -> Bool {
        return name != "Guest" && email != "unknown@hook.com"
    }
    
    public func getFullName() -> String {
        return "\(name) \(lastName)"
    }
}
