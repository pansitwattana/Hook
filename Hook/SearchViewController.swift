//
//  SearchViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 1/31/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var stores = ["Sixth Dorm Resturant", "Sushi"]
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "storeCell")
        
        cell.textLabel?.text = stores[indexPath.row]
        
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        index = indexPath.row
        
        self.performSegue(withIdentifier: "segueOrder", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let store = self.stores[self.index]
        
        if segue.identifier == "segueOrder" {
            if let destination = segue.destination as? OrderViewController {
                destination.SetStore(store: store)
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
