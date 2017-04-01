//
//  SearchStoreViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 3/29/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchStoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var stores = NSMutableArray()
    //var storesSearch = Store()
    var index = 0
    
    var storeCount = 0
    
    var textToSearch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func GetLocation() -> (Double, Double) {
        return (0, 0)
    }
    
    public func SetSearchText(keyword: String) {
        textToSearch = keyword
        print("Start loading Store...")
        Request.getSearchJson(keyword: textToSearch) {
            (error, searchJson) in
            if error != nil {
                print("error: \(error!)")
            }
            else {
                self.SetStoresFromJson(json: searchJson!)
            }
        }
    }
    
    
    public func SearchByLocation() {
        let coordinate = GetLocation()
        Request.getSearchJson(location: coordinate) {
            (error, searchJson) in
            self.SetStoresFromJson(json: searchJson!)
        }
    }
    
    func SearchStoreByText(text: String) {
        Request.getSearchJson(keyword: text) {
            (error, searchJson) in
            self.SetStoresFromJson(json: searchJson!)
        }
    }
    
    func SetStoresFromJson(json: JSON) {
        
        if (json != JSON.null){
            HookAPI.parseStores(json: json, stores: self.stores)
            
            self.storeCount = self.stores.count
            
            self.tableView.reloadData()
            
        }
        else {
            print("No Search Match Result")
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storeCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as! StoreTableViewCell
        
        if let store = stores[indexPath.row] as? Store {
            cell.name.text = store.name
            cell.distanceLabel.text = "< " + String(store.getDistance()) + " km"
            
            if store.open {
                cell.statusImage.image = #imageLiteral(resourceName: "status_online")
            }
            else {
                cell.statusImage.image = #imageLiteral(resourceName: "status_offline")
            }
            
            
            let url = URL(string: store.imgUrl)
            
            print("cell change \(store.name)")
            if store.doneLoadImg {
                cell.mainImage.image = store.imageView
            }
            else {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        store.imageView = UIImage(data: data!)
                        store.doneLoadImg = true
                        cell.mainImage.image = store.imageView
                    }
                }
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        index = indexPath.row
        print("Start perform")
        self.performSegue(withIdentifier: "segueOrder", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let store = self.stores[self.index] as? Store {
            print("Selected \(store.name)")
            if segue.identifier == "segueOrder" {
                if let destination = segue.destination as? MenuOrderViewController{
                    destination.SetStore(store: store)
                }
            }
        }
    }
}
