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
    var notificationViewController: UIViewController!
    
    var searchStoreViewController: UIViewController!
    
    
    var viewControllers: [UIViewController]!
    
    var selectedIndex: Int = 0
    
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
            print("error")
        }
        
        notificationViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        searchStoreViewController = storyboard.instantiateViewController(withIdentifier: "SearchStoreViewController")
        
        print("Load Tab View \(searchStoreViewController.description)")
        
        viewControllers = [homeViewController, notificationViewController, searchStoreViewController]
        
        buttons[selectedIndex].isSelected = true
        
        didPressTab(buttons[selectedIndex])
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBAction func didPressTab(_ sender: UIButton) {
        
        let previousIndex = selectedIndex
        
        showView(index: sender.tag)
        
        if previousIndex < buttons.count {
            
            buttons[previousIndex].isSelected = false
            
        }
        
        sender.isSelected = true
        
        
        
        
    }
    
    func showView(index: Int) {
        
        let previousIndex = selectedIndex
        
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
            if let home = homeViewController as? HomeViewController {
                home.actionButtonPress()
                showView(index: 2)
            }
//        case searchStoreViewController:
//            if let search = searchStoreViewController as? SearchStoreViewController {
//                print("show advance search")
//            }
            
        default:
            print("did Press in Tab is not work")
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
}
