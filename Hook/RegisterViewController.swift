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
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
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
                showAlert(title: "Failed to register", text: "Passwords are not match")
                //popup password is not match
            }
        }
        else {
            showAlert(title: "Failed to register", text: "Please fill the blanks")
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
                    self.showAlert(title: "Connection Error", text: "code: 404")
                }
                else {
                    print(responseJson!)
                    if self.validateRegister(json: responseJson!) {
                        User.current = User(params: userParam)
                        self.dismiss(animated: true, completion: nil)
                        //self.performSegue(withIdentifier: "homeSegue", sender: self)
                    }
                }
            })
        }
        else {
            //plz wait
        }
    }
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func validateRegister(json: JSON) -> Bool {
        if let response = json["response"].string {
            if response == "success" {
                return true
            }
            else {
                showAlert(title: "Failed to register", text: response)
                return false
            }
        }
        else {
            print("cant parse json")
            return false
        }
    }
    
    public func showAlert(title: String, text: String) {
        let alert =  UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}


