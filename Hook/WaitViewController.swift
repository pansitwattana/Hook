//
//  WaitViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 1/31/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class WaitViewController: UIViewController {

    @IBOutlet weak var hookWaitImage: UIImageView!
    
    var order = Order()
    
    var timer = Timer()
    
    var hookImageNameSet = [#imageLiteral(resourceName: "hook_sleep_mid"), #imageLiteral(resourceName: "hook_sleep_right"), #imageLiteral(resourceName: "hook_sleep_mid"), #imageLiteral(resourceName: "hook_sleep_left")]
    
    var menus = NSMutableArray()
    
    var store = Store(name: "-")
    
    var index = 0
    
    @IBOutlet weak var waitLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func SetMenus(menus: NSMutableArray) {
        self.menus = menus
    }
    
    func SetStore(store: Store) {
        self.store = store
    }
    
    func SetOrder(order: Order) {
        self.order = order
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(WaitViewController.animate), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
        
        waitLabel.text = "Wait \(order.queue) Queues."
        timeLabel.text = "Estimate wait time \(order.time) minutes"
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        Request.cancelOrder(orderID: 1, {
            (error, response) in
            if error != nil {
                print(error!)
            }
            else {
                print(response!)
                self.dismiss(animated: true, completion: nil)
            }
        })
    }

    func animate() {
        index += 1
        if index >= hookImageNameSet.count{
            index = 0
        }
        hookWaitImage.image = hookImageNameSet[index]
    }
}
