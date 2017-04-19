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
    
//    func testGetParams() {
//        
//        let orderParam: Parameters = [
//            "Comment": "ok",
//            "Name": "Guest",
//            "Store_ID": 1,
//            "LastName": "Unknown",
//            "MenuList": [0, 1],
//            "ID": 1,
//            "Status": 0,
//            "Date": "0"
//        ]
//        
//        order.comment = "ok"
//        order.id = 1
//        order.storeId = 1
//        order.status = .Wait
//        
//        let menu = Menu(name: "test")
//        menu.id = 0
//        let menu2 = Menu(name: "test2")
//        menu2.id = 1
//        
//        order.AddMenu(menu: menu)
//        order.AddMenu(menu: menu2)
//        
//        let expectedParam = orderParam.description
//        
//        let actualParam = order.GetParam().description
//        
//        XCTAssert(expectedParam == actualParam, "\(expectedParam) not equals \(actualParam)")
//    }
    
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
        if order.menus.count > 0 {
            XCTAssert(order.menus[0].id == 111)
            XCTAssert(order.menus[1].name == "test2")
        }
    }
    
    func testReduceMenu() {
        let menu = Menu(name: "test")
        menu.id = 111
        menu.price = 22
        let menu2 = Menu(name: "test2")
        menu2.id = 222
        menu2.price = 33
        order.AddMenu(menu: menu)
        order.AddMenu(menu: menu2)
        order.ReduceMenu(menu: menu)
        XCTAssert(!order.menus.isEmpty)
        XCTAssert(order.menus.count == 1)
        if order.menus.count > 0 {
            XCTAssert(order.menus[0].id == 222)
            XCTAssert(order.menus[0].name == "test2")
        }
    }
    
    func testAddAndReduceMenu3Time() {
        let menu = Menu(name: "test")
        menu.id = 111
        menu.price = 22
        let menu2 = Menu(name: "test2")
        menu2.id = 222
        menu2.price = 33
        order.AddMenu(menu: menu)
        order.AddMenu(menu: menu2)
        order.ReduceMenu(menu: menu)
        order.ReduceMenu(menu: menu)
        order.AddMenu(menu: menu)
        order.AddMenu(menu: menu2)
        order.ReduceMenu(menu: menu)
        order.ReduceMenu(menu: menu)
        order.AddMenu(menu: menu)
        order.AddMenu(menu: menu)
        order.AddMenu(menu: menu2)
        order.ReduceMenu(menu: menu)
        XCTAssert(!order.menus.isEmpty)
        XCTAssert(order.menus.count == 2)
        if order.menus.count > 0 {
            XCTAssert(order.menus[0].id == 222)
            XCTAssert(order.menus[0].name == "test2", "Expected test, Actual \(order.menus[0].name)")
            XCTAssert(order.menus[0].count == 3, "Expected 3, Actual \(order.menus[0].name)")
            XCTAssert(order.menus[1].id == 111)
            XCTAssert(order.menus[1].name == "test", "Expected test, Actual \(order.menus[1].name)")
            XCTAssert(order.menus[1].count == 1, "Expected 1, Actual \(order.menus[1].count)")
        }
    }
    
    func testReduceMenuMoreThanItHas() {
        let menu = Menu(name: "test")
        menu.id = 111
        menu.price = 22
        let menu2 = Menu(name: "test2")
        menu2.id = 222
        menu2.price = 33
        order.AddMenu(menu: menu)
        order.AddMenu(menu: menu)
        order.AddMenu(menu: menu2)
        order.ReduceMenu(menu: menu2)
        order.ReduceMenu(menu: menu)
        order.ReduceMenu(menu: menu2)
        order.ReduceMenu(menu: menu)
        order.ReduceMenu(menu: menu)
        XCTAssert(order.menus.isEmpty)
        XCTAssert(order.menus.count == 0)
    }
    
    func testReduceMenuWithoutAnyMenu() {
        let menu = Menu(name: "test")
        menu.id = 111
        menu.price = 22
        let menu2 = Menu(name: "test2")
        menu2.id = 222
        menu2.price = 33
        order.ReduceMenu(menu: menu2)
        order.ReduceMenu(menu: menu)
        XCTAssert(order.menus.isEmpty)
        XCTAssert(order.menus.count == 0)
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
        XCTAssert(menu.count == 2, "Expected Count of menu \(2), Actual \(menu.count)")
        XCTAssert(sum == 44, "Expected 44, Actual \(sum)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testIsDone() {
        
        let order = Order()
        order.queue = 2
        
        order.Set(id: 0, queue: 0, time: 0, status: .Done)
        
        //var isDone = order.IsDone()
        XCTAssert(order.IsDone())
    }
    
    func testIsCancel() {
        
        let order = Order()
        order.queue = 2
        
        order.Set(id: 0, queue: 0, time: 0, status: .Cancel)
        
        //var isDone = order.IsDone()
        XCTAssert(!order.IsDone())
        XCTAssert(order.IsCancel())
    }
    
}
