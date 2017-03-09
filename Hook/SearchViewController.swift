//
//  SearchViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 1/31/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var stores = ["Sixth Dorm Resturant", "Sushi"]
  	
    var storesSearch = Store()
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let requestURL: NSURL = NSURL(string: "http://jqhook.azurewebsites.net/search")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let array = json as? [Any] {
                    if let stores = array.first {
                        print(stores)
                    }
                }
            }
        }
        
        task.resume()
 */

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
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "storeCell")
        
        //cell.textLabel?.text = stores[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as! SearchTableViewCell
        
        cell.name.text = stores[indexPath.row]
        
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
