//
//  HeapSdkTests.swift
//  HeapSdkTests
//
//  Created by Christophe Vichery on 11/5/21.
//

import XCTest
import Alamofire
@testable import HeapSdk

class HeapSdkTests: XCTestCase {
    
    var hsdk: HSdk!
    var hapi: HApi!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        try super.setUpWithError()
        hsdk = HSdk()
        hapi = HApi.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        hapi = nil
        hsdk = nil
        try super.tearDownWithError()
    }
    
    func testHsdkInit() throws {
        hapi = HApi.shared
        XCTAssertNotNil(hapi)
    }
    
    func testHsdkPostEvent() throws {
        let expectation = self.expectation(description: "testHsdkPostEvent")
        
        let parameters: Parameters = [
            "type": "press up",
            "class": "UIButton",
            "timestamp": 66411.111603125,
            "location": "(x: 32.5, y: 26.0)",
            "info": "the user just pressed a button"
        ]
        
        var json: Dictionary<String, Any> = [:]
        
        hapi.hapiPostEvent(parameters: parameters) { jsonBack in
            json = jsonBack
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(json["type"] as! String, "press up", "json answer is empty")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
