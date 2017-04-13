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
    @IBOutlet weak var loadingview: NVActivityIndicatorView!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tabViewController: TabViewController!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var userLocation:(Double, Double)!
    
    var stores = NSMutableArray()

    var index = 0
    
    var storeCount = 0
    
    var textToSearch = ""
    
    var focusOnSearch = false
    
    public func setMain(tabView: TabViewController) {
        self.tabViewController = tabView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingview.type = .ballClipRotatePulse
        loadingview.color = .yellow
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabViewController.actionButton.setBackgroundImage(#imageLiteral(resourceName: "home_hook_search"), for: .normal)
        
        print("response to search")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if stores.count > 0 {
            print("reload data")
            tableView.reloadData()
        }
        else {
            print("no stores set")
        }
        
        if focusOnSearch {
            searchBar.text = ""
            searchBar.becomeFirstResponder()
        }
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        print("Search do action")
    }
    
    func hideLoadingProgress() {
        loadingview.stopAnimating()
    }
    
    func showLoadingProgress() {
        loadingview.startAnimating()
    }
    
    public func SetStores(stores: NSMutableArray, focusOnSearch: Bool) {
        print("set stores \(stores.count)")
        self.stores = stores
        self.storeCount = stores.count
        self.focusOnSearch = focusOnSearch
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
            showLoadingProgress()
            Request.getSearchJson(location: userLocation!) {
                (error, searchJson) in
                self.hideLoadingProgress()
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
        showLoadingProgress()
        Request.getSearchJson(keyword: textToSearch) {
            (error, searchJson) in
            self.hideLoadingProgress()
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
        showLoadingProgress()
        Request.getSearchJson(keyword: text) {
            (error, searchJson) in
            self.hideLoadingProgress()
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storeCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as! StoreTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
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
                cell.mainImage.image = #imageLiteral(resourceName: "logo_hook")
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
        else {
            print("cant parse store")
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        index = indexPath.row
        if let store = self.stores[index] as? Store {
            tabViewController.ActionToMenuOrder(store: store)
        }
        else {
            print("did Select Store Error")
        }
    }
}
