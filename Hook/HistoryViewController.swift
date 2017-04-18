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
    
    @IBOutlet weak var recentlyOrderTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Order.current.IsOrdering() {
            currentOrderView.isHidden = false
            showOrder(order: Order.current)
        }
        else {
            currentOrderView.isHidden = true
        }
    }
    
    func showOrder(order: Order) {
        
    }
}
