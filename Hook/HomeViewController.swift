//
//  HomeViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 2/18/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//
import SwiftyJSON
import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate {
    
    var tabViewController: TabViewController!
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    @IBOutlet weak var recommendCollectoinView: UICollectionView!

    @IBOutlet weak var fastestCollectionView: UICollectionView!
    
    var searchType = SearchType.Text
    
    var recommendStores = NSMutableArray()
    
    var popularStores = NSMutableArray()
    
    var fastestStores = NSMutableArray()
    
    private var refreshControl: UIRefreshControl!
    
    @IBAction func nearbyButtonClick(_ sender: Any) {
        print("nearbyClick")
        
        tabViewController.ActionToStore(type: .Location)
    }

    public func setMain(tabView: TabViewController) {
        self.tabViewController = tabView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Loading Home Page...")
        Request.Home({
            (error, json) in
            if error != nil {
                print(error!)
            }
            else {
                self.splitStoresList(json: json!)
            }
        })
        
        refreshControl = UIRefreshControl()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading")
        refreshControl.addTarget(self, action: #selector(	HomeViewController.refreshData), for: .valueChanged)
        scrollView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if User.current.isOrdering {
            self.tabViewController.actionButton.setBackgroundImage(#imageLiteral(resourceName: "home_hook_logo"), for: .normal)
        }
        else {
            self.tabViewController.actionButton.setBackgroundImage(#imageLiteral(resourceName: "home_hook_search"), for: .normal)
        }
    }
    
    @IBAction func storeCatPressed(_ sender: UIButton) {
        tabViewController.showView(tab: .category)
    }
    public func refreshData() {
        Request.Home({
            (error, json) in
            if error != nil {
                print(error!)
            }
            else {
                self.splitStoresList(json: json!)
            }
        })
        refreshControl.endRefreshing()
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        if !User.current.isOrdering {
            self.tabViewController.ActionToStoreWithDefault(storesToShow: recommendStores, focus: true)
        }
        else {
            self.tabViewController.showView(tab: .wait)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func seeAllPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("see all Popular")
            tabViewController.ActionToStoreWithDefault(storesToShow: popularStores, focus: false)
        case 1:
            print("see all Recommend")
            tabViewController.ActionToStoreWithDefault(storesToShow: recommendStores, focus: false)
        case 2:
            print("see all Fastest")
            tabViewController.ActionToStoreWithDefault(storesToShow: fastestStores, focus: false)
        default:
            print("no button tag \(sender.tag)")
        }
    }
    
    func splitStoresList(json: JSON) {
        let jsonData = json
        if jsonData != JSON.null {
            for (type, storeListJson) : (String, JSON) in jsonData {
                let stores = NSMutableArray()
                HookAPI.parseStores(json: storeListJson, stores: stores)
                switch type {
                case "Popular":
                    popularStores = stores
                    popularCollectionView.reloadData()
                case "Recommend":
                    recommendStores = stores
                    recommendCollectoinView.reloadData()
                case "Fast":
                    fastestStores = stores
                    fastestCollectionView.reloadData()
                default:
                    print("There is no \(type)")
                }
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        
        switch collectionView
        {
        case popularCollectionView:
            if let store = popularStores[index] as? Store {
                tabViewController.ActionToMenuOrder(store: store)
            }
        case recommendCollectoinView:
            if let store  = recommendStores[index] as? Store {
                tabViewController.ActionToMenuOrder(store: store)
            }
        case fastestCollectionView:
            if let store = fastestStores[index] as? Store {
                tabViewController.ActionToMenuOrder(store: store)
            }
        default:
            print("error on click collection view")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case popularCollectionView:
            return popularStores.count
        case recommendCollectoinView:
            return recommendStores.count
        case fastestCollectionView:
            return fastestStores.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case popularCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularCell",
                                                          for: indexPath) as! StoreCollectionViewCell

            if indexPath.row < popularStores.count {
                if let store = popularStores[indexPath.row] as? Store {
                    cell.storeName.text = store.name
                    cell.setStar(rate: store.rating)
                    
                    let url = URL(string: store.thumnailUrl)
                    
                    if store.doneLoadThumnail {
                        cell.storeImage.image = store.thumnailImageView
                    }
                    else {
                        cell.storeImage.image = #imageLiteral(resourceName: "search_loading")
                        DispatchQueue.global().async {
                            
                            let data = try? Data(contentsOf: url!)
                            
                            if data != nil {
                                DispatchQueue.main.async {
                                
                                    store.thumnailImageView = UIImage(data: data!)
                                    store.doneLoadThumnail = true
                                    cell.storeImage.image = store.thumnailImageView
                                
                                }
                            }
                        }
                    }
                }
            }
            return cell
            
        case recommendCollectoinView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCell",
                                                          for: indexPath) as! StoreCollectionViewCell

            if indexPath.row < recommendStores.count {
                if let store = recommendStores[indexPath.row] as? Store {
                    cell.storeName.text = store.name
                    cell.setStar(rate: store.rating)
                    let url = URL(string: store.thumnailUrl)
                    
                    if store.doneLoadThumnail {
                        cell.storeImage.image = store.thumnailImageView
                    }
                    else {
                        cell.storeImage.image = #imageLiteral(resourceName: "search_loading")
                        DispatchQueue.global().async {
                            
                            let data = try? Data(contentsOf: url!)
                            
                            if data != nil {
                                DispatchQueue.main.async {
                                    
                                    store.thumnailImageView = UIImage(data: data!)
                                    store.doneLoadThumnail = true
                                    cell.storeImage.image = store.thumnailImageView
                                    
                                }
                            }
                        }
                    }
                }
            }
            return cell
        case fastestCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fastestCell",
                                                          for: indexPath) as! StoreCollectionViewCell

            if indexPath.row < fastestStores.count {
                if let store = fastestStores[indexPath.row] as? Store {
                    cell.storeName.text = store.name
                    cell.setStar(rate: store.rating)
                    let url = URL(string: store.thumnailUrl)
                    
                    if store.doneLoadThumnail {
                        cell.storeImage.image = store.thumnailImageView
                    }
                    else {
                        cell.storeImage.image = #imageLiteral(resourceName: "search_loading")
                        DispatchQueue.global().async {
                            
                            let data = try? Data(contentsOf: url!)
                            
                            if data != nil {
                                DispatchQueue.main.async {
                                    
                                    store.thumnailImageView = UIImage(data: data!)
                                    store.doneLoadThumnail = true
                                    cell.storeImage.image = store.thumnailImageView
                                    
                                }
                            }
                        }
                    }
                }
            }
            return cell
        default:
            print("error cannot set to collectionview (HomeViewController)")
            return collectionView.visibleCells[0]
        }
    }
    
}
