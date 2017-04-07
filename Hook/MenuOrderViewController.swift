//
//  MenuOrderViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 3/26/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class MenuOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var firstCat: UIButton!
    @IBOutlet weak var secondCat: UIButton!
    @IBOutlet weak var thirdCat: UIButton!
    @IBOutlet weak var forthCat: UIButton!
    
    var store = Store(name: "not assigned")
    
    var order = Order()
    
    var menus = NSMutableArray()
    
    var menusToShow = NSMutableArray()
    
    var catSelected = "Food"
    
    @IBAction func doChangeCat(_ sender: UIButton) {
        switch sender {
        case firstCat:
            catSelected = store.categories[0]
        case secondCat:
            catSelected = store.categories[1]
        case thirdCat:
            catSelected = store.categories[2]
        case forthCat:
            catSelected = store.categories[3]
        default:
            catSelected = "Food"
        }
        self.menusToShow = self.filterCategory(menus: self.menus);
        self.tableView.reloadData()
    }
    @IBOutlet weak var tableView: UITableView!
    //do not have user -> default customer id = 1
    func SetStore(store: Store) {
        self.store = store
        self.order.setUser(customerUser: User.current, storeId: store.id)
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
                self.menusToShow = self.menus
                self.tableView.reloadData()
            }
        })
    }
    
    func filterCategory(menus: NSMutableArray) -> NSMutableArray {
        let newMenus = NSMutableArray()
        
        for menu in (menus as NSArray as! [Menu]) {
            if menu.catagory == catSelected {
                newMenus.add(menu)
            }
        }
        
        return newMenus
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menusToShow.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuOrderTableViewCell
        
        if indexPath.row < menusToShow.count {
            if let menu = menusToShow[indexPath.row] as? Menu {
                cell.nameLabel.text = menu.name
                cell.priceLabel.text = menu.GetPriceWithCurrency()
                if menu.count > 0 {
                    cell.countLabel.text = String(menu.count)
                }
                else {
                    cell.countLabel.text = ""
                }
                
                if menu.isLoadDone {
                    cell.storeImg.image = menu.img
                }
                else {
                    let url = URL(string: menu.imgUrl)
                    print("loading : " + menu.imgUrl)
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        DispatchQueue.main.async {
                            menu.isLoadDone = true
                            if data != nil {
                                menu.img = UIImage(data: data!)
                                cell.storeImg.image = menu.img
                            }
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "Remove") { action, index in
            if let menu = self.menusToShow[index.row] as? Menu {
                print("remove menu \(menu.name)")
                menu.count = 0
                self.order.RemoveMenu(menu: menu)
                self.tableView.reloadRows(at: [index], with: UITableViewRowAnimation.automatic)
            }
            
        }
        more.backgroundColor = .lightGray
        
        return [more]
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let index = indexPath.row
        if let menu = menusToShow[index] as? Menu {
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