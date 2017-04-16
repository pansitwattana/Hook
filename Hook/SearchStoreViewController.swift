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
    
    var tabViewController: TabViewController!
    
    let activityData = ActivityData(message: "Loading...", messageFont: UIFont(name: "Bangnampueng", size: 20), type: NVActivityIndicatorType.cubeTransition, minimumDisplayTime: 2000)
    
    var locationManager: CLLocationManager = CLLocationManager()
    var userLocation:(Double, Double)!
    
    var stores = NSMutableArray()

    var index = 0
    
    var storeCount = 0
    
    var textToSearch = ""
    
    var focusOnSearch = false
    
    var willShowLoading = false
    
    public func setMain(tabView: TabViewController) {
        self.tabViewController = tabView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabViewController.actionButton.setBackgroundImage(#imageLiteral(resourceName: "home_hook_search"), for: .normal)
        
        self.tableView.rowHeight = view.frame.height * 0.34
        
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
        
        if willShowLoading {
            showLoadingProgress()
            print("Show loading")
            willShowLoading = false
        }
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        print("Search do action")
    }
    
    func hideLoadingProgress() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    func showLoadingProgress() {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
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
            Request.getSearchJson(location: userLocation!) {
                (error, searchJson) in
                if (error != nil) {
                    print(error!)
                    self.hideLoadingProgress()
                }
                else {
                    self.SetStoresFromJson(json: searchJson!)
                    self.hideLoadingProgress()
                    self.SortStoresByDistance(stores: self.stores)
                    self.UpdateSearch()
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
            UpdateSearch()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    public func SetSearchText(keyword: String) {
        showLoadingProgress()
        textToSearch = keyword
        print("Start loading Store...")
        Request.getSearchJson(keyword: textToSearch) {
            (error, searchJson) in
            self.hideLoadingProgress()
            if error != nil {
                print("error: \(error!)")
            }
            else {
                self.SetStoresFromJson(json: searchJson!)
                self.UpdateSearch()
            }
        }
    }
    
    
    public func SearchByLocation() {
        focusOnSearch = false
        if CheckLocationServices() {
            if #available(iOS 9.0, *) {
                willShowLoading = true
                print("set willShowLoading")
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
            self.UpdateSearch()
        }
    }
    
    func SetStoresFromJson(json: JSON) {
        
        if (json != JSON.null){
            HookAPI.parseStores(json: json, stores: self.stores)
        }
        else {
            print("No Search Match Result")
        }
        
    }
    
    func SortStoresByDistance(stores: NSMutableArray) {
        if (stores.count > 0) {
            for i in 1..<stores.count {
                var y = i
                let store1 = stores[y] as! Store
                let store2 = stores[y - 1] as! Store
                while y > 0 && store1.distance < store2.distance {
                    swap(&stores[y - 1], &stores[y])
                    y -= 1
                }
            }
        }
    }
//    
//    func printAllStores() {
//        for store in stores as! [Store] {
//            print(store.id)
//        }
//    }
    
    func UpdateSearch() {
        self.storeCount = self.stores.count
        
        self.tableView.reloadData()
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
            
            if store.hasDistance() {
                cell.distanceLabel.text = "< " + store.getDistance() + " km"
            }
            else {
                cell.distanceLabel.text = ""
            }
            
            
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
                cell.mainImage.image = #imageLiteral(resourceName: "search_loading")
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
