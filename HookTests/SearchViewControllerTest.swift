//
//  SearchViewControllerTest.swift
//  Hook
//
//  Created by Pansit Wattana on 3/20/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import XCTest

@testable import Hook

class SearchViewControllerTest: XCTestCase {
    var searchView: SearchViewController!
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        searchView = storyboard.instantiateInitialViewController() as! SearchViewController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetLocation() {
        let location = searchView.GetLocation()
        XCTAssert((0, 0) == location)
    }
}
