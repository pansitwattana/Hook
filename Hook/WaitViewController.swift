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
    
    var checkOrderSubmit = false
    
    var hookImageNameSet = [#imageLiteral(resourceName: "hook_sleep_mid"), #imageLiteral(resourceName: "hook_sleep_right"), #imageLiteral(resourceName: "hook_sleep_mid"), #imageLiteral(resourceName: "hook_sleep_left")]

    var index = 0
    
    @IBOutlet weak var waitLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

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
        if (!checkOrderSubmit) {
            checkOrderSubmit = true
            
            print("cancel order id: \(order.id)")
            
            Request.cancelOrder(orderID: order.id, {
                (error, response) in
                if error != nil {
                    print(error!)
                    self.checkOrderSubmit = false
                }
                else {
                    print(response!)
                    self.performSegue(withIdentifier: "cancelSegue", sender: self)
                }
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cancelSegue" {
            
        }
    }
    
    func animate() {
        index += 1
        if index >= hookImageNameSet.count{
            index = 0
        }
        hookWaitImage.image = hookImageNameSet[index]
    }
}
