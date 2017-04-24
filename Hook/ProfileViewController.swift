//
//  ProfileViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 4/9/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    var tabView: TabViewController!
    
    func setMain(tabView: TabViewController) {
        self.tabView = tabView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func doLogout(_ sender: Any) {
        User.Logout()
        
        self.tabView.BackAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameLabel.text = User.current.getFullName()
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        print("profile do action")
        
        
    }
    
}
