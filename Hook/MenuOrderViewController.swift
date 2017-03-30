//
//  MenuOrderViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 3/26/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class MenuOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var store = Store(name: "-")
    
    var order = Order()
    
    var menus = NSMutableArray()
    
    @IBOutlet weak var tableView: UITableView!
    //do not have user -> default customer id = 1
    func SetStore(store: Store) {
        self.store = store
        self.order.storeId = store.id
        self.order.customerId = User.current.id
    }
    @IBAction func orderSubmit(_ sender: Any) {
        if order.menus.count > 0 {
            performSegue(withIdentifier: "orderSegue", sender: self)
        }
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Start loading Menu from \(store.name)")
        Request.getMenuJson(store: store.name, {
            (error, json) in
            if error != nil {
                print(error!)
            }
            else {
                HookAPI.parseMenus(json: json!, menus: self.menus)
                self.tableView.reloadData()
            }
        })
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuOrderTableViewCell
        
        if indexPath.row < menus.count {
            if let menu = menus[indexPath.row] as? Menu {
                cell.nameLabel.text = menu.name
                cell.priceLabel.text = menu.GetPriceWithCurrency()
                cell.storeImg.image = menu.img
                if menu.count > 0 {
                    cell.countLabel.text = String(menu.count)
                }
                else {
                    cell.countLabel.text = ""
                }
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let index = indexPath.row
        if let menu = menus[index] as? Menu {
            print(menu.name + " is selected")
            order.AddMenu(menu: menu)
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderSegue" {
            if let destination = segue.destination as? SummaryViewController{
                destination.SetOrder(order: self.order)
                destination.SetStore(store: self.store)
            }
        }
    }
}
