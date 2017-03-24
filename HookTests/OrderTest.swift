//
//  OrderTest.swift
//  Hook
//
//  Created by Pansit Wattana on 3/23/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import XCTest

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
            XCTAssert(order.menus[0] == menu.id)
        }

    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
