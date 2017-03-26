//
//  OrderTest.swift
//  Hook
//
//  Created by Pansit Wattana on 3/23/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import XCTest
import Alamofire

@testable import Hook

class OrderTest: XCTestCase {
    
    var order = Order()
    var menusSelected = NSMutableArray()
    
    override func setUp() {
        super.setUp()
        order = Order()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        menusSelected.removeAllObjects()
        order = Order()
    }
    
    func testSetMenus() {
        let menu = Menu(name: "test")
        menu.id = 111
        menusSelected.add(menu)
        order.SetMenus(menus: menusSelected)
        
        XCTAssert(!order.menus.isEmpty)
        XCTAssert(order.menus.count == 1)
        if order.menus.count > 0{
            XCTAssert(order.menus[0].id == menu.id)
            XCTAssert(order.menus[0].name == menu.name)
        }

    }
    
    func testGetMenuListID() {
        let menu = Menu(name: "test")
        menu.id = 111
        menu.price = 22
        let menu2 = Menu(name: "test2")
        menu2.id = 222
        menu2.price = 33
        order.AddMenu(menu: menu)
        order.AddMenu(menu: menu2)
        
        let menuListExpected = [111, 222]
        
        let menuListID = order.GetMenuListID()
        
        XCTAssert(menuListID == menuListExpected)
    }
    
    func testGetParams() {
        let orderParam: Parameters = [
            "Comment" : "ok",
            "Customer_ID" : 1,
            "Date" : "22",
            "ID" : 1,
            "Store_ID" : 1,
            "Type" : "Undone",
            "MenuList" : [
                0, 1
            ]
        ]
        
        order.comment = "ok"
        order.customerId = 1
        order.date = "22"
        order.id = 1
        order.storeId = 1
        order.type = "Undone"
        
        let menu = Menu(name: "test")
        menu.id = 0
        let menu2 = Menu(name: "test2")
        menu2.id = 1
        
        order.AddMenu(menu: menu)
        order.AddMenu(menu: menu2)
        
        
        let comment = order.GetParam().index(forKey: "Comment")
        let customer_id = order.GetParam().index(forKey: "Customer_ID")
        let date = order.GetParam().index(forKey: "Data")
        let id = order.GetParam().index(forKey: "ID")
        let store_id = order.GetParam().index(forKey: "Store_ID")
        let type = order.GetParam().index(forKey: "Type")
        let menuList = order.GetParam().index(forKey: "MenuList")
        
        let expectedParam = orderParam.description
        
        let actualParam = order.GetParam().description
        
        XCTAssert(expectedParam == actualParam, "\(expectedParam) not equals \(actualParam)")
        
        XCTAssert(comment == orderParam.index(forKey: "Comment"), "Failed comment \(comment)")
        XCTAssert(customer_id == orderParam.index(forKey: "Customer_ID"), "Failed \(customer_id)")
        XCTAssert(date == orderParam.index(forKey: "Data"), "Failed \(date)")
        XCTAssert(id == orderParam.index(forKey: "ID"), "Failed \(id)")
        XCTAssert(store_id == orderParam.index(forKey: "Store_ID"), "Failed \(store_id)")
        XCTAssert(type == orderParam.index(forKey: "Type"), "Failed \(type)")
        XCTAssert(menuList == orderParam.index(forKey: "MenuList"), "Failed \(menuList)")
    }
    
    func testAddMenu() {
        let menu = Menu(name: "test")
        menu.id = 111
        menu.price = 22
        let menu2 = Menu(name: "test2")
        menu2.id = 222
        menu2.price = 33
        order.AddMenu(menu: menu)
        order.AddMenu(menu: menu2)
        XCTAssert(!order.menus.isEmpty)
        XCTAssert(order.menus.count == 2)
        if order.menus.count > 0{
            XCTAssert(order.menus[0].id == 111)
            XCTAssert(order.menus[1].name == "test2")
        }
    }
    
    func testSumPriceCase2Menu() {
        let menu = Menu(name: "test")
        menu.id = 111
        menu.price = 22
        let menu2 = Menu(name: "test2")
        menu2.id = 222
        menu2.price = 33
        order.AddMenu(menu: menu)
        order.AddMenu(menu: menu2)
        
        let sum = order.GetSumPrice()
        
        XCTAssert(order.menus.count == 2, "Set Order is invalue")
        XCTAssert(sum == 55, "Expected 55, Actual \(sum)")
        
    }
    
    func testSumPriceCaseSameMenu() {
        let menu = Menu(name: "test")
        menu.id = 111
        menu.price = 22
        order.AddMenu(menu: menu)
        order.AddMenu(menu: menu)
        
        let sum = order.GetSumPrice()
        
        XCTAssert(order.menus.count == 1, "Set Order is invalue")
        XCTAssert(sum == 44, "Expected 44, Actual \(sum)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
