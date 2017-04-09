//
//  TabViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 4/6/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

public enum Tab {
    case home
    case login
    case search
    case order
    case summary
    case wait
    case register
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
    
    var viewControllers: [UIViewController]!
    
    var selectedIndex: Int = -1
    
    var previousIndex: Int = -1
    
    var isOrdering = false
    
    var stackIndexes: [Int] = []
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        
        registerViewController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController")
        
        if let registerView = registerViewController as? RegisterViewController {
            registerView.setMain(tabView: self)
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
        
        viewControllers = [homeViewController, loginViewController, searchStoreViewController, menuOrderViewController, summaryViewController, waitViewController, registerViewController]
        
        showView(tab: .home)
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBAction func didPressTab(_ sender: UIButton) {
        
        self.previousIndex = selectedIndex
        
        showView(index: sender.tag)
        
        if previousIndex < buttons.count {
            
//            buttons[previousIndex].isSelected = false
            
        }
        
//        sender.isSelected = true
        
        
        
        
    }
    
    func showView(tab: Tab) {
        let index = tab.hashValue
        print("show view of \(String(describing: tab))")
        showView(index: index)
    }
    
    func showView(index: Int) {
        
        if selectedIndex != index {
            
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
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        BackAction()
    }
    
    public func BackAction() {
        print(stackIndexes)
        if stackIndexes.count > 0 {
            let index = stackIndexes.popLast()
            if index != nil && selectedIndex != index {
                showView(index: index!)
                stackIndexes.removeLast()
                print(index!)
            }
        }
    }
    
    public func ActionFromLoginSubmit () {
        if previousIndex >= 0 && previousIndex != 6{
            showView(index: previousIndex)
        }
        else {
            showView(index: 0)
        }
    }
    
    public func ActionGoToLogin() {
        showView(tab: .login)
    }
    
    public func ActionFromRegisterSubmit () {
        ActionGoToLogin()
    }
    
    public func ActionGoToRegister() {
        showView(tab: .register)
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
