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
    @IBOutlet var starButton: [UIButton]!
    
    
    var tabView: TabViewController!
    
    var store = Store(name: "Store")
    
    var rate = 5
    
    func setMain(tabView: TabViewController) {
        self.tabView = tabView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func starDidPress(_ sender: UIButton) {
        self.rate = sender.tag
        
        let index = sender.tag
        var count = 0
        for j in 0...index - 1{
            starButton[j].setBackgroundImage(#imageLiteral(resourceName: "store_rate_glow"), for: .normal)
            count += 1
        }
        if count < starButton.count {
            for i in count...starButton.count - 1{
                starButton[i].setBackgroundImage(#imageLiteral(resourceName: "store_rate_gray"), for: .normal)
            }
        }
    }
    
    @IBAction func lookMapDidPress(_ sender: Any) {
        
    }
    
    @IBAction func feedbackDidPress(_ sender: Any) {
        print("submit \(rate)")
        
    }
}
