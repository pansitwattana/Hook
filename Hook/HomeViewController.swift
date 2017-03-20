//
//  HomeViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 2/18/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var textToSearch = ""
    
    var searchType = SearchType.Text
    
    @IBAction func backButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nearbyButtonClick(_ sender: Any) {
        self.searchType = SearchType.Location
        self.performSegue(withIdentifier: "segueSearch", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            if let destination = segue.destination as? SearchViewController {
                switch self.searchType {
                case .Text:
                    destination.SetSearchText(keyword: textToSearch)
                case .Location:
                    destination.SetSearchText(keyword: textToSearch)
                case .Popular:
                    destination.SetSearchText(keyword: textToSearch)
                }
            }
        }
    }
}
