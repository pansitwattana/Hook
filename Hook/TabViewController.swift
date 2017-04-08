//
//  TabViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 4/6/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class TabViewController: UIViewController {

    @IBOutlet weak var actionButton: UIButton!
    
    var homeViewController: UIViewController!
    var loginViewController: UIViewController!
    
    var searchStoreViewController: UIViewController!
    var menuOrderViewController: UIViewController!
    var summaryViewController: UIViewController!
    var waitViewController: UIViewController!
    
    var viewControllers: [UIViewController]!
    
    var selectedIndex: Int = 0
    
    var previousIndex: Int = -1
    
    var isOrdering = false
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons[0].setImage(#imageLiteral(resourceName: "main_home_clicked"), for: .selected)
        
        buttons[1].setImage(#imageLiteral(resourceName: "main_notification_clicked"), for: .selected)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        if let homeView = homeViewController as? HomeViewController {
            homeView.setMain(tabView: self)
        }
        else {
            print("set main in home view error")
        }
        
        loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        if let loginView = loginViewController as? LoginViewController {
            loginView.setMain(tabView: self)
        }
        
        searchStoreViewController = storyboard.instantiateViewController(withIdentifier: "SearchStoreViewController")
        
        if let searchStore = searchStoreViewController as? SearchStoreViewController {
            searchStore.setMain(tabView: self)
        }
        else {
            print("set main in search store error")
        }
        
        menuOrderViewController = storyboard.instantiateViewController(withIdentifier: "MenuOrderViewController")
        
        summaryViewController = storyboard.instantiateViewController(withIdentifier: "SummaryViewController")
        
        if let summary = summaryViewController as? SummaryViewController {
            summary.setMain(tabView: self)
        }
        
        waitViewController = storyboard.instantiateViewController(withIdentifier: "WaitViewController")
        
        print("Load Tab View \(searchStoreViewController.description)")
        
        viewControllers = [homeViewController, loginViewController, searchStoreViewController, menuOrderViewController, summaryViewController, waitViewController]
        
        buttons[selectedIndex].isSelected = true
        
        didPressTab(buttons[selectedIndex])
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBAction func didPressTab(_ sender: UIButton) {
        
        self.previousIndex = selectedIndex
        
        showView(index: sender.tag)
        
        if previousIndex < buttons.count {
            
            buttons[previousIndex].isSelected = false
            
        }
        
        sender.isSelected = true
        
        
        
        
    }
    
    func showView(index: Int) {
        
        self.previousIndex = selectedIndex
        
        selectedIndex = index
        
        let previousVC = viewControllers[previousIndex]
        
        previousVC.willMove(toParentViewController: nil)
        
        previousVC.view.removeFromSuperview()
        
        previousVC.removeFromParentViewController()
        
        let vc = viewControllers[selectedIndex]
        
        addChildViewController(vc)
        
        vc.view.frame = contentView.bounds
        
        contentView.addSubview(vc.view)
        
        vc.didMove(toParentViewController: self)
    }
    
    @IBAction func didPressAction(_ sender: UIButton) {
        switch viewControllers[selectedIndex] {
        case homeViewController:
            if !isOrdering {
                if let home = homeViewController as? HomeViewController {
                    home.actionButtonPress()
                    showView(index: 2)
                }
            }
            else {
                showView(index: 5)
            }
        case searchStoreViewController:
            if let search = searchStoreViewController as? SearchStoreViewController {
                print("show advance search")
            }
        case menuOrderViewController:
            if let menuOrder = menuOrderViewController as? MenuOrderViewController {
                if let summary = summaryViewController as? SummaryViewController {
                    summary.SetStore(store: menuOrder.store)
                    summary.SetOrder(order: menuOrder.order)
                    showView(index: 4)
                }
                else {
                    print("Cant Get Summary View Controlle")
                }
            }
        case summaryViewController:
            if let summary = summaryViewController as? SummaryViewController {
                summary.submit(sender)
            }
        case waitViewController:
            if let waitView = waitViewController as? WaitViewController {
                if waitView.isDone {
                    showView(index: 0)
                    self.isOrdering = false
                }
            }   
        default:
            print("did Press in Tab is not work")
        }
    }
    
    public func ActionLogin () {
        if previousIndex >= 0 {
            showView(index: previousIndex)
        }
        else {
            showView(index: 0)
        }
    }
    
    public func ActionToStore(type: SearchType) {
        print("Action To Store")
//        let store = searchStoreViewController as! SearchStoreViewController
        if let store = searchStoreViewController  as? SearchStoreViewController{
            switch type {
            case .Location:
                store.SearchByLocation()
            case .Popular:
                store.SearchStoreByText(text: "Popular")
            default:
                store.SearchStoreByText(text: "Recommend")
            }
            showView(index: 2)
        }
        else {
            print("error")
        }
    }
    
    public func ActionToMenuOrder(store: Store) {
        if let menuOrderView = menuOrderViewController as? MenuOrderViewController {
            menuOrderView.SetStore(store: store)
            showView(index: 3)
        }
        else {
            print("action to menu order error")
        }
    }
    
    public func ActionToWaitView(order: Order) {
        if let waitView = waitViewController as? WaitViewController {
            waitView.SetOrder(order: order)
            self.isOrdering = true
            showView(index: 5)
        }
    }
}
