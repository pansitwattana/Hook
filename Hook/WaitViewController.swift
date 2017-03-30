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
    
    @IBOutlet weak var submitButton: UIButton!
    var hookImageNameSet = [#imageLiteral(resourceName: "hook_sleep_mid"), #imageLiteral(resourceName: "hook_sleep_right"), #imageLiteral(resourceName: "hook_sleep_mid"), #imageLiteral(resourceName: "hook_sleep_left")]

    var okImage = #imageLiteral(resourceName: "btn_ok")
    
    var index = 0
    
    var isDone = false
    
    @IBOutlet weak var waitLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    func SetOrder(order: Order) {
        self.order = order
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(WaitViewController.animate), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
        
        updateQueue(order: self.order)
        
        waitOrderDone()
    }
    
    func waitOrderDone() {
        print("Start Wait for Order done")
        if (!isDone) {
            Request.getOrder(orderID: self.order.id, {
                (error, response) in
                if error != nil {
                    print(error!)
                    self.waitOrderDone()
                }
                else {
                    print(response!)
                    self.order.SetQueue(json: response!)
                    if self.order.IsDone() {
                        print("order done")
                        self.showDone(order: self.order)
                    }
                    else {
                        print("order not done yet \(self.order.queue)")
                        self.updateQueue(order: self.order)
                        self.waitOrderDone()
                    }
                }
            })
        }
    }
    
    func showDone(order: Order) {
        isDone = true
        waitLabel.text = "Your order is now complete"
        timeLabel.text = ""
        submitButton.setImage(okImage.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func updateQueue(order: Order) {
        waitLabel.text = "Wait \(order.queue) Queues."
        timeLabel.text = "Estimate wait time \(order.time) minutes"
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        if (isDone) {
            self.performSegue(withIdentifier: "finishSegue", sender: self)
        }
        else {
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
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cancelSegue" {
            
        }
        else if segue.identifier == "finishSegue" {
            
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
