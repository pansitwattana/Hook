//
//  SearchViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 1/31/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    @IBOutlet weak var tableView: UITableView!
  	
    var stores = NSMutableArray()
    //var storesSearch = Store()
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let api = HookAPI()
        if let keyword = searchBar.text! as String? {
        
            
            Alamofire.request(api.URL + "search").responseJSON {
                response in
                
                api.parseStore(JSONData: response.data!, stores: self.stores)
                
                print("Call Search")
                for item in self.stores {
                    if let store = item as? Store {
                        print(store.name)
                    }
                }
                self.tableView.reloadData()
            }
        }
        else {
            print("No Result")
        }
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "storeCell")
        
        //cell.textLabel?.text = stores[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as! SearchTableViewCell
        
        if let store = stores[indexPath.row] as? Store {
            cell.name.text = store.name
        }

        return cell
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
