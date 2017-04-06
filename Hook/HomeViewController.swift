//
//  HomeViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 2/18/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var textToSearch = ""
    
    var searchType = SearchType.Text
    
    @IBAction func backButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    @IBAction func nearbyButtonClick(_ sender: Any) {
        self.searchType = SearchType.Location
        self.performSegue(withIdentifier: "segueSearch", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
