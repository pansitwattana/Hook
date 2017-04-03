//
//  LoginViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 1/31/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userLabel: UITextField!
    
    
    @IBOutlet weak var passLabel: UITextField!
    
    var isLoginClick = false
    
    @IBOutlet weak var login: UIButton!
    @IBAction func login(_ sender: Any) {
        User.current = User()
        let user = userLabel.text!
        let password = passLabel.text!
        if (!isLoginClick && user != "" && password != "") {
            isLoginClick = true
            Request.Login(user: user, password: password, {
                (error, userJson) in
                self.isLoginClick = false
                if (error != nil) {
                    print(error!)
                }
                else {
                    User.current = User(userJson: userJson!)
                    print(userJson!)
                    if (User.current.name != "Guest") {
                        print("Log on as \(User.current.name)")
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }
                    else {
                        print("Cannot login by user: \(user)")
                    }
                }
            })
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
