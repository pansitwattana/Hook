//
//  StoreViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 4/17/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController {
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var openDayLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var tabView: TabViewController!
    
    var store = Store(name: "Store")
    
    func setMain(tabView: TabViewController) {
        self.tabView = tabView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showStoreDetail()
    }
    
    public func setStore(store: Store) {
        self.store = store
    }
    
    func showStoreDetail() {
        if store.imageView != nil {
            storeImage.image = store.imageView
        }
        else {
            let url = URL(string: store.imgUrl)
            storeImage.image = #imageLiteral(resourceName: "search_loading")
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    if data != nil {
                        self.store.imageView = UIImage(data: data!)
                        self.store.doneLoadImg = true
                        self.storeImage.image = self.store.imageView
                    }
                }
            }
        }
        
        storeName.text = store.name
        
        ratingLabel.text = String(store.rating)
    }
    
    @IBAction func starDidPress(_ sender: Any) {
        
    }
    
    @IBAction func lookMapDidPress(_ sender: Any) {
        
    }
    
    @IBAction func feedbackDidPress(_ sender: Any) {
        
    }
}
