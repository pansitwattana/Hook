//
//  WaitViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 1/31/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//
import UserNotifications
import UIKit
import NVActivityIndicatorView

class WaitViewController: UIViewController{

    @IBOutlet weak var hookWaitImage: UIImageView!
    
    @IBOutlet weak var cancelButton: UIButton!
    var tabViewController: TabViewController!
    
    let activityData = ActivityData(message: "Loading...", messageFont: UIFont(name: "Bangnampueng", size: 20), type: NVActivityIndicatorType.cubeTransition, minimumDisplayTime: 1000)
    
//    let activity = ActivityData(size: <#T##CGSize?#>, message: <#T##String?#>, messageFont: <#T##UIFont?#>, type: <#T##NVActivityIndicatorType?#>, color: <#T##UIColor?#>, padding: <#T##CGFloat?#>, displayTimeThreshold: <#T##Int?#>, minimumDisplayTime: <#T##Int?#>, backgroundColor: <#T##UIColor?#>, textColor: <#T##UIColor?#>)
    
    var order = Order()
    
    var timer : Timer?

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
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        print("Wait do action")
        if checkDone() {
            tabViewController.showView(tab: .home)
            tabViewController.ResetBackStack()
        }
        else {
            print("Toggle Hook Button")
        }
    }
    
    func backButtonPressed() {
        print("Wait do action")
        if checkDone() {
            tabViewController.showView(tab: .home)
            tabViewController.ResetBackStack()
        }
        else {
            alertCancel()
//            self.tabViewController.showAlert(title: "Alert!", text: "Your order will be cancel, do you want to continue?")
        }
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
        
        self.tabViewController.actionButton.setBackgroundImage(#imageLiteral(resourceName: "home_hook_logo"), for: .normal)
        
        isDone = false
        updateQueue(order: self.order)
        cancelButton.isHidden = false
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
                    else if self.order.IsCancel() {
                        print("order is cancel")
                        self.hideLoadingProgress()
                        self.showCancel(order: self.order)
                    }
                    else {
                        print("order not done yet \(self.order.queue)")
                        User.current.isOrdering = true
                        self.updateQueue(order: self.order)
                        self.waitOrderDone()
                    }
                }
            })
        }
    }
    
    func showCancel(order: Order) {
        self.tabViewController.actionButton.setBackgroundImage(#imageLiteral(resourceName: "home_hook_ok"), for: .normal)
        pushNotification()
        stopAnimate()
        cancelButton.isHidden = true
        User.current.isOrdering = false
        alreadySetAnimated = false
        hookWaitImage.image = #imageLiteral(resourceName: "hook_complete")
        isDone = true
        waitLabel.text = "Your order was canceled"
        timeLabel.text = ""
    }
    
    func showDone(order: Order) {
        self.tabViewController.actionButton.setBackgroundImage(#imageLiteral(resourceName: "home_hook_ok"), for: .normal)
        pushNotification()
        stopAnimate()
        cancelButton.isHidden = true
        User.current.isOrdering = false
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
        return isDone
    }
    
    func updateQueue(order: Order) {
        waitLabel.text = "Wait \(order.queue) Queues."
        timeLabel.text = "Estimate wait time \(order.time) minutes"
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        requestCancel()
    }
    
    func requestCancel() {
        if (isDone) {
            self.tabViewController.ActionToHome()
        }
        else {
            print("cancel order id: \(order.id)")
            showLoadingProgress()
            Request.cancelOrder(orderID: order.id, {
                (error, response) in
                if error != nil {
                    print(error!)
                    self.hideLoadingProgress()
                }
                else {
                    print(response!)
                    User.current.isOrdering = false
                }
            })
        }
    }
    
    func hideLoadingProgress() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    func showLoadingProgress() {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func alertCancel() {
        let alert = UIAlertController(title: "Alert!", message: "The Order will be cancel, do you want to continue?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
            self.requestCancel()
        })
        alert.addAction(UIAlertAction(title: "No", style: .default) { action in
            
        })
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func animate() {
        index += 1
        if index >= hookImageNameSet.count{
            index = 0
        }
        hookWaitImage.image = hookImageNameSet[index]
    }
}
