//
//  OrderViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 1/31/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleNavigator: UINavigationItem!
    
    var store = Store(name: "store")
    
    var menus = NSMutableArray()
    
    var menusSelected = NSMutableArray()
    
    var menuCount = 0
    
    var order = Order()

    override func viewDidLoad() {
        super.viewDidLoad()
       
//        menus.add(Menu(name: "egg"))
//        menus.add(Menu(name: "first"))
//        menus.add(Menu(name: "a"))
//        menus.add(Menu(name: "b"))
//        menus.add(Menu(name: "c"))
//        menus.add(Menu(name: "d"))
//        menus.add(Menu(name: "e"))
//        
//        

        
        
        Request.getMenuJson(store: store.name, {
            (error, json) in
            if error != nil {
                print(error!)
            }
            else {
                HookAPI.parseMenus(json: json!, menus: self.menus)
                self.menuCount = self.menus.count
                self.collectionView.reloadData()
            }
        })
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func sendOrder(_ sender: Any) {
        if menusSelected.count > 0 {
            order.SetMenus(menus: menusSelected)
            menusSelected.removeAllObjects()
            Request.postOrderJson(order: order.GetParam(), {
                (error, queueJson) in
                if error != nil {
                    print(error!)
                }
                else {
                    print(queueJson!)
                    let queue = queueJson!
                    if queue != JSON.null {
                        let id = queue["ID"].int,
                        time = queue["time"].int,
                        queue = queue["Queue"].int
                        do {
                            self.order.Set(id: id!, queue: queue!, time: time!)
                            self.performSegue(withIdentifier: "orderSegue", sender: self)
                        }
                    }
                    
                }
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //do not have user -> default customer id = 1
    func SetStore(store: Store) {
        self.store = store
        self.order.storeId = store.id
        self.order.customerId = 1
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        if let menu = menus[index] as? Menu {
            print(menu.name + " is selected")
            menusSelected.add(menu)
        }   
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell",
                                                      for: indexPath) as! MenuCollectionViewCell
        
        print(indexPath)
        if indexPath.row < menus.count {
            if let menu = menus[indexPath.row] as? Menu {
                cell.nameLabel.text = menu.name
                cell.priceLabel.text = String(menu.price)
                cell.img.image = menu.img
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderSegue" {
            if let destination = segue.destination as? WaitViewController{
                destination.SetMenus(menus: self.menusSelected)
                destination.SetStore(store: self.store)
                destination.SetOrder(order: self.order)
            }
        }
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
