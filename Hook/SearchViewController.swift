//
//  SearchViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 1/31/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit
import SwiftyJSON

public enum SearchType {
    case Text
    case Location
    case Popular
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    @IBOutlet weak var tableView: UITableView!
  	
    var stores = NSMutableArray()
    //var storesSearch = Store()
    var index = 0
    
    var storeCount = 0
    
    var textToSearch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = textToSearch
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text! as String? {
            Request.getSearchJson(keyword: searchText) {
                (error, searchJson) in
                self.SetStoresFromJson(json: searchJson!)
            }
            self.view.endEditing(true)
        }
        else {
            print("No search result")
        }
    }
    
    func GetLocation() -> (Double, Double) {
        return (0, 0)
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storeCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as! SearchTableViewCell
        
        if let store = stores[indexPath.row] as? Store {
            cell.name.text = store.name
            cell.img.image = store.img
            cell.detail.text = store.detail
            
        }

        return cell
    }
    @IBAction func backButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        index = indexPath.row
        
        self.performSegue(withIdentifier: "segueOrder", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let store = self.stores[self.index] as? Store {
            if segue.identifier == "segueOrder" {
                if let destination = segue.destination as? OrderViewController{
                    destination.SetStore(store: store)
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
