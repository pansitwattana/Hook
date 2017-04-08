//
//  SummaryViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 3/24/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit
import SwiftyJSON

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var totalLabel: UILabel!
    
    var tabView: TabViewController!
    
    var order = Order()
    
    var store = Store(name: "-")
    
    var checkSubmit = false
    
    func SetOrder(order: Order) {
        self.order = order
    }
    
    func SetStore(store: Store) {
        self.store = store
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func setMain(tabView: TabViewController) {
        self.tabView = tabView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        totalLabel.text = "Total " + String(order.GetSumPrice())  + " Baht"
        tableView.reloadData()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submit(_ sender: UIButton) {
        if (!checkSubmit) {
            if (User.current.isLogin()) {
                checkSubmit = true
                print("Submit Order \(order.GetParam())")
                Request.postOrderJson(order: order.GetParam(), {
                    (error, queueJson) in
                    if error != nil {
                        print(error!)
                    }
                    else {
                        print(queueJson!)
                        self.order.SetQueue(json: queueJson!)
                        self.tabView.ActionToWaitView(order: self.order)
//                        self.performSegue(withIdentifier: "summarySegue", sender: self)
                    }
                    self.checkSubmit = false
                })
            }
            else {
                self.tabView.showAlert(title: "Please Login", text: "You have to login before submit the order")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "summarySegue" {
            if let destination = segue.destination as? WaitViewController{
                destination.SetOrder(order: self.order)
            }
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.menus.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        
        let menu = order.menus[indexPath.row]
        
        cell.nameLabel.text = menu.name
        cell.priceLabel.text = String(menu.GetTotalPrice())
        cell.countLabel.text = String(menu.count)
        
        
        return cell
    }
}
