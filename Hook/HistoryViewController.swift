//
//  HistoryViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 4/15/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {


    @IBOutlet weak var currentOrderId: UILabel!
    @IBOutlet weak var currentOrderView: UIView!
    @IBOutlet weak var currentOrderImage: UIImageView!
    @IBOutlet weak var currentOrderStoreName: UILabel!
    @IBOutlet weak var currentOrderPrice: UILabel!
    @IBOutlet weak var currentOrderContraint: NSLayoutConstraint!
    
    @IBOutlet weak var recentlyOrderTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Order.current.IsOrdering() {
            showOrder(order: Order.current)
        }
        else {
            hideOrder()
        }
    }
    
    func hideOrder() {
        print("Hide order")
        currentOrderView.isHidden = true
        let newConstraint = self.currentOrderContraint.constraintWithMultiplier(multiplier: 0.01)
        self.view!.removeConstraint(self.currentOrderContraint)
        self.currentOrderContraint = newConstraint
        self.view!.addConstraint(currentOrderContraint)
        self.view!.layoutIfNeeded()
    }
    
    func showOrder(order: Order) {
        currentOrderView.isHidden = false
        print("Show Order")
        let newConstraint = self.currentOrderContraint.constraintWithMultiplier(multiplier: 0.25)
        self.view!.removeConstraint(self.currentOrderContraint)
        self.currentOrderContraint = newConstraint
        self.view!.addConstraint(currentOrderContraint)
        self.view!.layoutIfNeeded()
    }
}
extension NSLayoutConstraint {
    func constraintWithMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
