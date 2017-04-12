//
//  WaitViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 1/31/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//
import UserNotifications
import UIKit

class WaitViewController: UIViewController{

    @IBOutlet weak var hookWaitImage: UIImageView!
    
    var tabViewController: TabViewController!
    
    var order = Order()
    
    var timer : Timer?
    
    var checkOrderSubmit = false

    var hookImageNameSet = [#imageLiteral(resourceName: "hook_sleep_mid"), #imageLiteral(resourceName: "hook_sleep_right"), #imageLiteral(resourceName: "hook_sleep_mid"), #imageLiteral(resourceName: "hook_sleep_left")]

    var okImage = #imageLiteral(resourceName: "btn_ok")
    
    var index = 0
    
    var isDone = false
    
    var alreadySetAnimated = false
    
    @IBOutlet weak var waitLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    func SetOrder(order: Order) {
        self.order = order
    }
    
    var isGrantedNotificationAccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    public func setMain(tabView: TabViewController) {
        self.tabViewController = tabView
    }
    
    func startAnimate() {
        if timer == nil {
            timer = Timer.scheduledTimer(
                timeInterval: 0.3,
                target: self,
                selector: #selector(WaitViewController.animate),
                userInfo: nil,
                repeats: true)
            
        }
    }
    
    func stopAnimate() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !alreadySetAnimated {
            hookWaitImage.image = hookImageNameSet[0]
            startAnimate()
            alreadySetAnimated = true
        }
        
        isDone = false
        updateQueue(order: self.order)
        waitOrderDone()
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization( options: [.alert,.sound,.badge], completionHandler: {
                (granted,error) in
                self.isGrantedNotificationAccess = granted
                }
            )
        }
    }
    
    func waitOrderDone() {
        print("Start Wait for Order done")
        if (!isDone) {
            Request.getOrder(orderID: self.order.id, {
                (error, response) in
                if error != nil {
                    print(error!.code)
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
        pushNotification()
        stopAnimate()
        alreadySetAnimated = false
        hookWaitImage.image = #imageLiteral(resourceName: "hook_complete")
        isDone = true
        waitLabel.text = "Your order is now complete"
        timeLabel.text = ""
    }
    
    func pushNotification() {
        
        if isGrantedNotificationAccess {
            print("push notificaiton")
            // Define identifier
            //add notification code here
            
            if #available(iOS 10.0, *) {
                //Set the content of the notification
                let content = UNMutableNotificationContent()
                content.title = "Your Order is DONE!"
                content.subtitle = "Go To The Store to Get your menu"
                content.body = "Your food is done"
            
                //Set the trigger of the notification -- here a timer.
                let trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: 0.01,
                    repeats: false)
            
                //Set the request for the notification from the above
                let request = UNNotificationRequest(
                    identifier: "order done",
                    content: content,
                    trigger: trigger
                )
            
                //Add the notification to the currnet notification center
                UNUserNotificationCenter.current().add(
                    request, withCompletionHandler: nil)
            }
            else {
                print("notification is not allow")
            }
        }

    }
    
    public func checkDone() -> Bool {
        User.current.isOrdering = !isDone
        return isDone
    }
    
    func updateQueue(order: Order) {
        waitLabel.text = "Wait \(order.queue) Queues."
        timeLabel.text = "Estimate wait time \(order.time) minutes"
    }
    
    @IBAction func cancelOrder(_ sender: UIButton) {
        if (isDone) {
//            self.performSegue(withIdentifier: "finishSegue", sender: self)
            self.tabViewController.ActionToHome()
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
//                        self.performSegue(withIdentifier: "finishSegue", sender: self)
                        //popup
                        self.tabViewController.ActionToHome()
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
