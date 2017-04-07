//
//  SearchStoreViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 3/29/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import NVActivityIndicatorView

class SearchStoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var userLocation:(Double, Double)!
    
    var stores = NSMutableArray()

    var index = 0
    
    var storeCount = 0
    
    var textToSearch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("response to search")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        searchBar.text = ""
        searchBar.becomeFirstResponder()
    }

    func CheckLocationServices() -> Bool {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        return CLLocationManager.locationServicesEnabled()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(location.coordinate.latitude)")
        print("user longitude = \(location.coordinate.longitude)")
        
        
        userLocation = (location.coordinate.latitude, location.coordinate.longitude)
        if userLocation != nil {
            Request.getSearchJson(location: userLocation!) {
                (error, searchJson) in
                if (error != nil) {
                    print(error!)
                }
                else {
                    print(searchJson!)
                    self.SetStoresFromJson(json: searchJson!)
                }
            }
        }
        else {
            print("error cant set coordinate")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text! as String? {
            view.endEditing(true)
            textToSearch = keyword
            SetSearchText(keyword: textToSearch)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
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
        if CheckLocationServices() {
            if #available(iOS 9.0, *) {
                locationManager.requestLocation()
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            print("Location Service is disable!")
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
            
            print("cell change \(store.name) \(indexPath.row)")
            if store.doneLoadImg {
                cell.mainImage.image = store.imageView
            }
            else {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        if data != nil {
                            store.imageView = UIImage(data: data!)
                            store.doneLoadImg = true
                            cell.mainImage.image = store.imageView
                        }
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
