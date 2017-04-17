//
//  MenuOrderViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 3/26/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class MenuOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var allCat: UIButton!
    @IBOutlet weak var firstCat: UIButton!
    @IBOutlet weak var secondCat: UIButton!
    @IBOutlet weak var thirdCat: UIButton!
    @IBOutlet weak var forthCat: UIButton!
    
    var tabViewController: TabViewController!
    
    var store = Store(name: "not assigned")
    
    var order = Order()
    
    var menus = NSMutableArray()
    
    var menusToShow = NSMutableArray()
    
    var catSelected = "Food"
    
    var previousButtonSelected: UIButton!
    
    @IBAction func doChangeCat(_ sender: UIButton) {
        switch sender {
        case allCat:
            catSelected = "All"
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
        
        if previousButtonSelected != nil {
            previousButtonSelected.isSelected = false
        }
        
        sender.isSelected = true
        previousButtonSelected = sender
        
        self.menusToShow = self.filterCategory(menus: self.menus, cat: catSelected);
        self.tableView.reloadData()
    }
    @IBOutlet weak var tableView: UITableView!
    //do not have user -> default customer id = 1
    func SetStore(store: Store) {
        self.order = Order()
        self.store = store
        self.order.setUser(customerUser: User.current, storeId: store.id)
        fetchingMenus()
    }
    
    func fetchingMenus() {
        print("Loading Menu from \(store.name)")
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

    public func setMain(tabView: TabViewController) {
        self.tabViewController = tabView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabViewController.actionButton.setBackgroundImage(#imageLiteral(resourceName: "home_hook_ok"), for: .normal)
    }
    
    @IBAction func showDetailDidPress(_ sender: Any) {
        tabViewController.ActionShowStoreDetail(store: self.store)
    }
    
    func filterCategory(menus: NSMutableArray, cat: String) -> NSMutableArray {
        let newMenus = NSMutableArray()
        
        if cat == "All" {
            return menus
        }
        else {
            for menu in (menus as NSArray as! [Menu]) {
                if menu.catagory == cat {
                    newMenus.add(menu)
                }
            }
        }
        
        return newMenus
    }
    
    public func increaseOrder(index: Int) {
        if let menuSelected = menusToShow[index] as? Menu {
            order.AddMenu(menu: menuSelected)
        }
    }
    
    public func increaseMenu(sender: UIButton) {
        print(sender.tag)
    }
    
    public func decreaseOrder(index: Int) {
        print("decrease menu")
    }
    
    public func decreaseMenu(sender: UIButton) {
        print(sender.tag)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menusToShow.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuOrderTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if indexPath.row < menusToShow.count {
            if let menu = menusToShow[indexPath.row] as? Menu {
                cell.nameLabel.text = menu.name
                cell.priceLabel.text = menu.GetPriceWithCurrency()
                cell.countLabel.text = String(menu.count)
                cell.statusImage.image = #imageLiteral(resourceName: "status_online")
                if menu.count == 0 {
                    cell.checkImage.image = #imageLiteral(resourceName: "order_uncheck")
                }
                else {
                    cell.checkImage.image = #imageLiteral(resourceName: "order_check")
                }
                
                cell.increaseAction = {
                    (cell) in
//                    print(tableView.indexPath(for: cell)!.row)
                    self.order.AddMenu(menu: menu)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                
                cell.decreaseAction = {
                    (cell) in
//                    print(tableView.indexPath(for: cell)!.row)
                    self.order.ReduceMenu(menu: menu)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                
                if menu.isLoadDone {
                    cell.storeImg.image = menu.img
                }
                else {
                    let url = URL(string: menu.imgUrl)
                    print("loading : " + menu.imgUrl)
                    cell.storeImg.image = #imageLiteral(resourceName: "order_loading")
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
    
//    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let more = UITableViewRowAction(style: .normal, title: "Remove") { action, index in
//            if let menu = self.menusToShow[index.row] as? Menu {
//                print("remove menu \(menu.name)")
//                menu.count = 0
//                self.order.RemoveMenu(menu: menu)
//                self.tableView.reloadRows(at: [index], with: UITableViewRowAnimation.automatic)
//            }
//            
//        }
//        more.backgroundColor = .lightGray
//        
//        return [more]
//    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("cell pressed")
//        let index = indexPath.row
//        if let menu = menusToShow[index] as? Menu {
//            print(menu.name + " is selected")
//            order.AddMenu(menu: menu)
//            self.tableView.reloadData()
//        }
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        print("menu order do action")
        if User.current.isLogin() {
            if order.containMenu() {
                tabViewController.ActionFromOrderSubmit(store: store,order: order)
            }
            else {
                tabViewController.showAlert(title: "Can not order!", text: "You did not select a menu")
            }
        }
        else {
            tabViewController.showAlert(title: "Please Login", text: "You have to login before submit the order")
        }
    }
}
