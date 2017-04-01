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
        
        totalLabel.text = "Total " + String(order.GetSumPrice())  + " Baht"
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submit(_ sender: Any) {
        if (!checkSubmit) {
            if (order.customerId != "" || order.customerId != "Guest") {
                checkSubmit = true
                print("Submit Order \(order.GetParam())")
                Request.postOrderJson(order: order.GetParam(), {
                    (error, queueJson) in
                    if error != nil {
                        self.checkSubmit = false
                        print(error!)
                    }
                    else {
                        self.checkSubmit = false
                        self.order.SetQueue(json: queueJson!)
                        self.performSegue(withIdentifier: "summarySegue", sender: self)
                    }
                })
            }
            else {
                print("Please Login Before Sent Order")
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
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
