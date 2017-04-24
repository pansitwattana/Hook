//
//  CategoryViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 4/23/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    
    var categoryList = ["Noodle",
        "Cafe",
        "Fastfood",
        "Bakery"
    ]
    
    var tabView: TabViewController!
    
    var catCount = 0
    
    func setMain(tabView: TabViewController) {
        self.tabView = tabView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catCount = categoryList.count
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        catCount = categoryList.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catCount
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabView.ActionToStore(category: categoryList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "categoryCell")
        
        cell.textLabel?.text = categoryList[indexPath.row]
        
        return cell
    }
    
}
