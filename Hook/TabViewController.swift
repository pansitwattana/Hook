//
//  TabViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 4/6/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

public enum Tab : Int {
    case home
    case profile
    case search
    case order
    case summary
    case wait
}


class TabViewController: UIViewController {

    @IBOutlet weak var actionButton: UIButton!
    
    var homeViewController: UIViewController!
    var loginViewController: UIViewController!
    
    var searchStoreViewController: UIViewController!
    var menuOrderViewController: UIViewController!
    var summaryViewController: UIViewController!
    var waitViewController: UIViewController!
    var registerViewController: UIViewController!
    var profileViewController: UIViewController!
    
    var imageButtons = [#imageLiteral(resourceName: "home_hook_logo"), #imageLiteral(resourceName: "home_hook_search")]
    
    var viewControllers: [UIViewController]!
    
    var selectedIndex: Int = -1
    
    var previousIndex: Int = -1

    
    var stackIndexes: [Int] = []
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.Load()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        if let homeView = homeViewController as? HomeViewController {
            homeView.setMain(tabView: self)
        }
        else {
            print("set main in home view error")
        }

        searchStoreViewController = storyboard.instantiateViewController(withIdentifier: "SearchStoreViewController")
        
        if let searchStore = searchStoreViewController as? SearchStoreViewController {
            searchStore.setMain(tabView: self)
        }
        else {
            print("set main in search store error")
        }
        
        menuOrderViewController = storyboard.instantiateViewController(withIdentifier: "MenuOrderViewController")
        
        if let menuOrder = menuOrderViewController as? MenuOrderViewController {
            menuOrder.setMain(tabView: self)
        }
        
        summaryViewController = storyboard.instantiateViewController(withIdentifier: "SummaryViewController")
        
        if let summary = summaryViewController as? SummaryViewController {
            summary.setMain(tabView: self)
        }
        
        waitViewController = storyboard.instantiateViewController(withIdentifier: "WaitViewController")
        
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        
        viewControllers = [homeViewController, profileViewController, searchStoreViewController, menuOrderViewController, summaryViewController, waitViewController]
        
        showView(tab: .home)
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var buttons: [UIButton]!
    
    func profileTabPressed() {
        actionButton.setBackgroundImage(imageButtons[0], for: .normal)
        print(User.current.name)
        if (User.current.isLogin()) {
            showView(tab: .profile)
        }
        else {
            performSegue(withIdentifier: "loginSegue", sender: self)
//            showView(tab: .login)
        }
    }
    
    func homeTabPressed() {
        actionButton.setBackgroundImage(imageButtons[1], for: .normal)
        
        showView(tab: .home)
    }
    
    @IBAction func didPressTab(_ sender: UIButton) {
        self.previousIndex = selectedIndex
        if sender.tag == 1 {
            profileTabPressed()
        }
        else {
            homeTabPressed()
        }
    }

    @IBAction func didPressAction(_ sender: UIButton) {
        switch viewControllers[selectedIndex] {
        case homeViewController:
            if !User.current.isOrdering {
                if let home = homeViewController as? HomeViewController {
                    home.actionButtonPress()
                    showView(tab: .search)
                }
            }
            else {
                showView(tab: .wait)
            }
        case searchStoreViewController:
            if let search = searchStoreViewController as? SearchStoreViewController {
                print("show advance search")
            }
        case menuOrderViewController:
            if let menuOrder = menuOrderViewController as? MenuOrderViewController {
                menuOrder.submit(sender)
            }
        case summaryViewController:
            if let summary = summaryViewController as? SummaryViewController {
                summary.submit(sender)
            }
        case waitViewController:
            if let waitView = waitViewController as? WaitViewController {
                if waitView.checkDone() {
                    showView(tab: .home)
                }
                else {
                    print("Toggle Hook Button")
                }
            }   
        default:
            print("did Press in Tab is not work")
        }
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        BackAction()
    }
    
    public func BackAction() {
        if stackIndexes.count > 0 {
            let index = stackIndexes.popLast()
            if index != nil && selectedIndex != index {
                showView(index: index!)
                stackIndexes.removeLast()
            }
        }
    }
    
//    public func ActionFromLoginSubmit () {
//        if previousIndex >= 0 && previousIndex != 6{
//            showView(index: previousIndex)
//        }
//        else {
//            showView(tab: .home)
//        }
//    }
//    
//    public func ActionGoToLogin() {
//        showView(tab: .login)
//    }
//    
//    public func ActionFromRegisterSubmit () {
//        ActionGoToLogin()
//    }
//    
//    public func ActionGoToRegister() {
//        showView(tab: .register)
//    }
//    
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
            showView(tab: .search)
        }
        else {
            print("error")
        }
    }
    
    public func ActionToMenuOrder(store: Store) {
        if let menuOrderView = menuOrderViewController as? MenuOrderViewController {
            menuOrderView.SetStore(store: store)
            showView(tab: .order)
        }
        else {
            print("action to menu order error")
        }
    }
    
    public func ActionFromOrderSubmit(store: Store, order: Order){
        if let summary = summaryViewController as? SummaryViewController {
            summary.SetStore(store: store)
            summary.SetOrder(order: order)
            showView(tab: .summary)
        }
        else {
            print("Cant Get Summary View Controlle")
        }
    }
    
    public func ActionToWaitView(order: Order) {
        if let waitView = waitViewController as? WaitViewController {
            waitView.SetOrder(order: order)
            showView(tab: .wait)
        }
    }
    
    public func ActionToHome() {
        showView(tab: .home)
    }

    public func showAlert(title: String, text: String) {
        let alert =  UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showView(tab: Tab) {
        let index = tab.hashValue
        
        showView(index: index)
    }
    
    func showView(index: Int) {
        
        if selectedIndex != index {
            
            print("Go To \(Tab(rawValue: index).debugDescription)")
            
            self.previousIndex = selectedIndex
            
            stackIndexes.append(previousIndex)
            
            selectedIndex = index
            
            if previousIndex < 0 {
                previousIndex = 0
            }
            
            let previousVC = viewControllers[previousIndex]
            
            previousVC.willMove(toParentViewController: nil)
            
            previousVC.view.removeFromSuperview()
            
            previousVC.removeFromParentViewController()
            
            if selectedIndex < 0 {
                selectedIndex = 0
            }
            
            let vc = viewControllers[selectedIndex]
            
            addChildViewController(vc)
            
            vc.view.frame = contentView.bounds
            
            contentView.addSubview(vc.view)
            
            vc.didMove(toParentViewController: self)
        }
    }
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)  
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
