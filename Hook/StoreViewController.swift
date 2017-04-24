//
//  StoreViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 4/17/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit
import SwiftyJSON

class StoreViewController: UIViewController {
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var openDayLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet var starButton: [UIButton]!
    
    
    var tabView: TabViewController!
    
    var store = Store(name: "Store")
    
    var rate = 0
    
    var feedbackPress = false
    
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
        priceLabel.text = "\(store.avgMoney) baht/person"
        storeName.text = store.name
        locationLabel.text = store.address
        telLabel.text = store.tel
        openTimeLabel.text = store.getOpenTime()
        ratingLabel.text = String(store.rating)
        reviewLabel.text = "\(store.review) reviews"
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
        let url = URL(string: "https://www.google.com/maps?q=\(store.coordinates.latitude),\(store.coordinates.longitude)")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func feedbackDidPress(_ sender: Any) {
        if rate != 0 {
            if !feedbackPress {
                feedbackPress = true
                if User.current.isLogin() {
                    let feedback = Feedback(msg: commentTextField.text!, rate: self.rate, store_id: self.store.id, sender: User.current.email, subject: "Feedback")
                    Request.postFeedback(feedback: feedback.getParam(), {
                        (error, response) in
                        self.feedbackPress = false
                        if error != nil {
                            print(error!)
                            self.tabView.showAlert(title: "Error to submit your feedback", text: "\(String(describing: error?.code))")
                        }
                        else {
                            let json = JSON(response!)
                            if json != JSON.null {
                                print("Success")
                                self.tabView.showAlert(title: "Thank for your feedback", text: "")
                            }
                            else {
                                print(json)
                                self.tabView.showAlert(title: "Error to submit your feedback", text: "\(json)")
                            }
                        }
                    })
                }
                else {
                    self.tabView.showAlert(title: "Can't Submit Your Feedback", text: "You do not log in")
                }
            }
        }
    }
}
