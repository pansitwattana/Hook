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
    
    var order = Order()

    //do not have user -> default customer id = 1
    func SetStore(store: Store) {
        self.store = store
        self.order.storeId = store.id
        self.order.customerId = User.current.id
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Request.getMenuJson(store: store.name, {
            (error, json) in
            if error != nil {
                print(error!)
            }
            else {
                HookAPI.parseMenus(json: json!, menus: self.menus)
                self.collectionView.reloadData()
            }
        })
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendOrder(_ sender: Any) {
        if order.menus.count > 0 {
            performSegue(withIdentifier: "orderSegue", sender: self)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        if let menu = menus[index] as? Menu {
            print(menu.name + " is selected")
            order.AddMenu(menu: menu)
        }   
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell",
                                                      for: indexPath) as! MenuCollectionViewCell
        
        print(indexPath)
        if indexPath.row < menus.count {
            if let menu = menus[indexPath.row] as? Menu {
                cell.nameLabel.text = menu.name
                cell.priceLabel.text = menu.GetPriceWithCurrency()
                cell.img.image = menu.img
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderSegue" {
            if let destination = segue.destination as? SummaryViewController{
                destination.SetOrder(order: self.order)
                destination.SetStore(store: self.store)
            }
        }
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
