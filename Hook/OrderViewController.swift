//
//  OrderViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 1/31/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var titleNavigator: UINavigationItem!
    
    var store = Store(name: "store")
    
    var menus = NSMutableArray()
    
    var menuCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        menus.add(Menu(name: "egg"))
        menus.add(Menu(name: "first"))
        menus.add(Menu(name: "a"))
        menus.add(Menu(name: "b"))
        menus.add(Menu(name: "c"))
        menus.add(Menu(name: "d"))
        menus.add(Menu(name: "e"))
        
        
        menuCount = menus.count
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func SetStore(store: Store) {
        self.store = store
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
            }
        }
        
        
        
        return cell
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
