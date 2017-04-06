//
//  RegisterViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 4/4/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//
import Alamofire
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

        // Do any additional setup after loading the view.
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        
        if email != nil && firstname != nil && password != nil && lastname != nil && confirmPass != nil {
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
                print("Password is not match")
                //popup password is not match
            }
        }
        else {
            print("Please fill al the blank")
            //popup plz fill the blank
        }
    }
    
    func SubmitToServer(userParam: Parameters) {
        if !checkSubmit {
            Request.Register(userParam: userParam, {
                (error, responseJson) in
                self.checkSubmit = true
                if error != nil {
                    print(error!)
                    //popup fail to connect server
                }
                else {
                    print(responseJson!)
                    self.performSegue(withIdentifier: "registerSegue", sender: self)
                }
            })
        }
        else {
            //plz wait
        }
    }
}
