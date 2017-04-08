//
//  RegisterViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 4/4/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//
import Alamofire
import SwiftyJSON
import UIKit

class RegisterViewController: UIViewController {

    var checkSubmit = false
    var tabViewController: TabViewController!
    
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }
    
    public func setMain(tabView: TabViewController) {
        self.tabViewController = tabView
    }
    
    @IBAction func back(_ sender: Any) {
        self.tabViewController.BackAction()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: Any) {
        
        let email = emailText.text
        let firstname = userText.text
        let lastname = lastNameText.text
        let password = passwordText.text
        let confirmPass = confirmPasswordText.text
        
        if email != "" && firstname != "" && password != "" && lastname != "" && confirmPass != "" {
            if password == confirmPass {
                let userParam: Parameters = [
                    "Email" : email!,
                    "Lastname" : lastname!,
                    "Name" : firstname!,
                    "Password" : password!,
                    "Type" : 0
                ]
                SubmitToServer(userParam: userParam)
            }
            else {
                self.tabViewController.showAlert(title: "Failed to register", text: "Passwords are not match")
                //popup password is not match
            }
        }
        else {
            self.tabViewController.showAlert(title: "Failed to register", text: "Please fill the blanks")
        }
    }
    
    func SubmitToServer(userParam: Parameters) {
        if !checkSubmit {
            checkSubmit = true
            Request.Register(userParam: userParam, {
                (error, responseJson) in
                self.checkSubmit = false
                if error != nil {
                    print(error!)
                    self.tabViewController.showAlert(title: "Connection Error", text: "code: 404")
                }
                else {
                    print(responseJson!)
                    if self.validateRegister(json: responseJson!) {
                        self.tabViewController.ActionFromRegisterSubmit()
                    }
                }
            })
        }
        else {
            //plz wait
        }
    }
    
    func validateRegister(json: JSON) -> Bool {
        if let response = json["response"].string {
            if response == "success" {
                return true
            }
            else {
                self.tabViewController.showAlert(title: "Failed to register", text: response)
                return false
            }
        }
        else {
            print("cant parse json")
            return false
        }
    }
}


