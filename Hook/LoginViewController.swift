//
//  LoginViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 1/31/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var userLabel: UITextField!
    
    @IBOutlet weak var passLabel: UITextField!
    
    var isLoginClick = false
    
    let activityData = ActivityData(message: "Loading...", messageFont: UIFont(name: "Bangnampueng", size: 20), type: NVActivityIndicatorType.cubeTransition)
    
    
    @IBOutlet weak var login: UIButton!

    @IBAction func submit(_ sender: Any) {
        loginRequest()
    }
    
    @IBAction func login(_ sender: UIButton) {
        loginRequest()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.userLabel {
            print("next")
            self.passLabel.becomeFirstResponder()
            return true
        }
        
        return false
    }
    
    func loginRequest() {
        let user = userLabel.text!
        let password = passLabel.text!
        if (!isLoginClick && user != "" && password != "") {
            print("Login Request")
            view.endEditing(true)
            User.current = User()
            showLoadingProgress()
            isLoginClick = true
            Request.Login(user: user, password: password, {
                (error, userJson) in
                self.isLoginClick = false
                self.hideLoadingProgress()
                if (error != nil) {
                    print(error!)
                    self.showAlert(title: "Connection Error", text: "Internet is unstable!")
                }
                else {
                    if self.isUserValidate(json: userJson!) {
                        User.Save()
                        self.dismiss(animated: true, completion: nil)
                        print("go to home")
                    }
                    else {
                        self.showError(json: userJson!)
                    }
                }
            })
        }
    }
    
    func isUserValidate(json: JSON?) -> Bool{
        User.current = User(userJson: json!)
        print(json!)
        if (User.current.isLogin()) {
            return true
        }
        else {
            return false
        }
    }
    
    func showError(json: JSON?) {
        self.showAlert(title: "Login Error", text: "User is incorrect")
    }
    
    func hideLoadingProgress() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    func showLoadingProgress() {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }

    @IBAction func signup(_ sender: Any) {
        performSegue(withIdentifier: "registerSegue", sender: self)
//        self.tabViewController.ActionGoToRegister()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("will did appear")
        if User.current.isLogin() {
            dismiss(animated: true, completion: nil)
        }
        else {
            print("no user login")
        }
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

