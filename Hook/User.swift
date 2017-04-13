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
        UserDefaults.standard.set(current.getDictionary(), forKey: "user_auth_token")
        print("User Saved")
    }
    
    public static func Load() {
        if let userDictionary = UserDefaults.standard.dictionary(forKey: "user_auth_token")
        {
            print(userDictionary)
            User.current = User()
            for (key, value) : (String, Any) in userDictionary {
                switch key {
                case "Email":
                    if let email = value as? String {
                        User.current.email = email
                    }
                    else {
                        print("Cant parse email")
                    }
                case "Type":
                    if let type = value as? String {
                        User.current.type = Int(type) ?? 0
                    }
                    else {
                        print("Cant parse type")
                    }
                case "Name":
                    if let name = value as? String {
                        User.current.name = name
                    }
                    else {
                        print("Cant parse name")
                    }
                case "Lastname":
                    if let lastname = value as? String {
                        User.current.lastName = lastname
                    }
                    else {
                        print("Cant parse last name")
                    }
                default:
                    print("Error, There is no key \(key)")
                }
            }
            
        }
        else {
            print(UserDefaults.standard.value(forKey: "user_auth_token") ?? "cant get User")
            print("Login as Guest")
            User.current = User()
        }
    }
    
    public func getDictionary() -> Dictionary<String, String> {
        let userDictionary = [
            "Email": self.email,
            "Type" : String(self.type),
            "Name" : self.name,
            "Lastname" : self.lastName
        ]
        return userDictionary
    }
    
    init(dict: Dictionary<String, String>) {
        
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
