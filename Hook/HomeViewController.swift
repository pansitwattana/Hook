//
//  HomeViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 2/18/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate {
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var textToSearch = ""
    
    var searchType = SearchType.Text
    
    var recommendStores = NSMutableArray()
    
    @IBAction func backButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    @IBAction func nearbyButtonClick(_ sender: Any) {
        self.searchType = SearchType.Location
        self.performSegue(withIdentifier: "segueSearch", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        recommendStores.add(Store(name: "test"))
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        textToSearch = ""        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text! as String? {
            textToSearch = keyword
            self.searchType = SearchType.Text
            self.performSegue(withIdentifier: "segueSearch", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueSearch" {
            if let destination = segue.destination as? SearchStoreViewController {
                switch self.searchType {
                case .Text:
                    destination.SetSearchText(keyword: textToSearch)
                case .Location:
                    destination.SearchByLocation()
                case .Popular:
                    destination.SetSearchText(keyword: textToSearch)
                }
            }
        }
        else if segue.identifier == "logoutSegue" {
            if let destination = segue.destination as? LoginViewController {
                destination.logout()
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
        print("selected \(index)")
//        if let menu = menus[index] as? Menu {
//            print(menu.name + " is selected")
//            order.AddMenu(menu: menu)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendStores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCell",
                                                      for: indexPath) as! StoreCollectionViewCell
        
        print(indexPath)
        if indexPath.row < recommendStores.count {
            if let store = recommendStores[indexPath.row] as? Store {
                
            }
        }
        
        return cell
    }
    
}
