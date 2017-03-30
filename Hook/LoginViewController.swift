//
//  LoginViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 1/31/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passLabel: UITextField!
    @IBOutlet weak var userLabel: UITextField!
    @IBOutlet weak var popUpView: UIView!
    
    @IBAction func login(_ sender: Any) {
        let user = userLabel.text!
        let password = passLabel.text!
        self.performSegue(withIdentifier: "loginSegue", sender: self)
//        if (user != "" && password != "") {
//            Request.Login(user: user, password: password, {
//                (error, userJson) in
//                if (error != nil) {
//                    print(error!)
//                }
//                else {
//                    User.current = User(userJson: userJson!)
//                    if (User.current.name != "Guest") {
//                        print("Log on as \(User.current.name)")
//                        self.performSegue(withIdentifier: "loginSegue", sender: self)
//                    }
//                    else {
//                        print("Cannot login by user: \(user)")
//                    }
//                }
//            })
//        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView.layer.cornerRadius = 10;
        popUpView.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            if let destination = segue.destination as? HomeViewController {
                
            }
        }
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
