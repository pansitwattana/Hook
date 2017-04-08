//
//  LoginViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 1/31/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var userLabel: UITextField!
    
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    
    @IBOutlet weak var passLabel: UITextField!
    
    var isLoginClick = false
    
    var tabViewController: TabViewController!
    
    
    @IBOutlet weak var login: UIButton!
    
    public func setMain(tabView: TabViewController) {
        self.tabViewController = tabView
    }
    
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
                    User.current = User(userJson: userJson!)
                    print(userJson!)
                    if (User.current.name != "Guest") {
                        print("Log on as \(User.current.name)")
                        self.tabViewController.ActionLogin()
                    }
                    else {
                        print("Cannot login by user: \(user)")
                        self.showAlert(title: "Login Error", text: "User is incorrect")
                    }
                }
            })
        }
    }
    
    func showAlert(title: String, text: String) {
        let alert =  UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideLoadingProgress() {
        loadingView.stopAnimating()
    }
    
    func showLoadingProgress() {
        loadingView.startAnimating()
    }
    
    func logout() {
        User.current = User()
    }
    
    @IBAction func signup(_ sender: Any) {
        performSegue(withIdentifier: "registerSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView.type = .ballClipRotatePulse
        loadingView.color = .yellow
        
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
