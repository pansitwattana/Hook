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
    case store
    case history
    case category
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
    var storeViewController: UIViewController!
    var historyViewController: UIViewController!
    var categoryViewController: UIViewController!
    
    var imageButtons = [#imageLiteral(resourceName: "home_hook_logo"), #imageLiteral(resourceName: "home_hook_search")]
    
    var viewControllers: [UIViewController]!
    
    var selectedIndex: Int = -1
    
    var previousIndex: Int = -1

    @IBOutlet weak var navigatorBar: UINavigationItem!
    
    var stackIndexes: [Int] = []
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.Load()
        
        initializeAllViews()
        
        
        
        actionButton.setBackgroundImage(#imageLiteral(resourceName: "home_hook_logo_selected"), for: .highlighted)
        
        //addNotificationButton()
        
        showView(tab: .home)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var buttons: [UIButton]!
    
    func addNotificationButton() {
        let notiImage: UIImage =  #imageLiteral(resourceName: "main_notification_clicked")
        
        let button = UIButton.init(type: .custom)
        button.setImage(notiImage, for: .normal)
        button.addTarget(self, action:#selector(TabViewController.notificationPressed), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 22, height: 24) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        navigatorBar.rightBarButtonItem = barButton
    }
    
    func notificationPressed() {
        showView(tab: .history)
    }
    
    func profileTabPressed() {
        print(User.current.name)
        if (User.current.isLogin()) {
            actionButton.setBackgroundImage(imageButtons[0], for: .normal)
            showView(tab: .profile)
        }
        else {
            performSegue(withIdentifier: "loginSegue", sender: self)
//            showView(tab: .login)
        }
    }
    
    func homeTabPressed() {
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
            if let home = homeViewController as? HomeViewController {
                home.actionButtonPressed(sender)
            }
        case profileViewController:
            if let profile = profileViewController as? ProfileViewController {
                profile.actionButtonPressed(sender)
            }
        case searchStoreViewController:
            if let search = searchStoreViewController as? SearchStoreViewController {
                search.actionButtonPressed(sender)
            }
        case menuOrderViewController:
            if let menuOrder = menuOrderViewController as? MenuOrderViewController {
                menuOrder.actionButtonPressed(sender)
            }
        case summaryViewController:
            if let summary = summaryViewController as? SummaryViewController {
                summary.actionButtonPressed(sender)
            }
        case waitViewController:
            if let waitView = waitViewController as? WaitViewController {
                waitView.actionButtonPressed(sender)
            }   
        default:
            print("did Press in Tab is not work")
        }
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        switch viewControllers[selectedIndex] {
        case waitViewController:
            if let waitView = waitViewController as? WaitViewController {
                waitView.backButtonPressed()
            }
        default:
            BackAction()
        }
        
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
    
    public func ResetBackStack() {
        stackIndexes.removeAll()
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
            showView(tab: .search)
        }
        else {
            print("error")
        }
    }
    
    public func ActionToStore(category: String) {
        print("\(category) selected")
        
        if let store = searchStoreViewController as? SearchStoreViewController {
            store.SearchByCategory(category: category)
            showView(tab: .search)
        }
        
    }
    
    public func ActionToStoreWithDefault(storesToShow: NSMutableArray, focus: Bool) {
        print("Will Show Stores")
        if let store = searchStoreViewController as? SearchStoreViewController {
            store.SetStores(stores: storesToShow, focusOnSearch: focus)
            showView(tab: .search)
        }
        else {
            print("error")
        }
    }
    
    public func ActionShowStoreDetail(store: Store) {
        if let storeView = storeViewController as? StoreViewController {
            storeView.setStore(store: store)
            showView(tab: .store)
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
            
            if let tab = Tab(rawValue: selectedIndex) {
                let titleString = String(describing: tab)
                navigatorBar.title = titleString.uppercaseFirst
            }
            
            let vc = viewControllers[selectedIndex]
            
            addChildViewController(vc)
            
            vc.view.frame = contentView.bounds
            
            contentView.addSubview(vc.view)
            
            vc.didMove(toParentViewController: self)
        }
    }
    
    func initializeAllViews() {
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
        
        if let wait = waitViewController as? WaitViewController {
            wait.setMain(tabView: self)
        }
        
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        
        if let profile = profileViewController as? ProfileViewController {
            profile.setMain(tabView: self)
        }
        
        storeViewController = storyboard.instantiateViewController(withIdentifier: "StoreViewController")
        
        if let store = storeViewController as? StoreViewController {
            store.setMain(tabView: self)
        }
        
        historyViewController = storyboard.instantiateViewController(withIdentifier: "HistoryViewController")
        
        categoryViewController = storyboard.instantiateViewController(withIdentifier: "CategoryViewController")
        
        if let category = categoryViewController as? CategoryViewController {
            category.setMain(tabView: self)
        }
        
        viewControllers = [homeViewController, profileViewController, searchStoreViewController, menuOrderViewController, summaryViewController, waitViewController, storeViewController, historyViewController, categoryViewController]
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

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
}
