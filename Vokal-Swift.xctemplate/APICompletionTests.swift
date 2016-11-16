//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import XCTest
@testable import ___PACKAGENAME___

class APICompletionTests: XCTestCase {
    
    let StandardTestTimeout = 3.0
    
    //MARK: - Test Lifecycle
    
    override static func setUp() {
        super.setUp()

        //Use mock protocol
        HTTPSessionManager.useMockData()
    }

    override static func tearDown() {
        //Stop using mock protocol
        HTTPSessionManager.useLiveData()

        super.tearDown()
    }

    //MARK: - Test generic closures in API completion

    func testDictionaryFetch() {
        //GIVEN: Using mock data and an async method
        let expectation = self.expectation(description: "Finish requesting dictionary")
        
        //WHEN: Requesting a URL that should return a dictionary
        MainAPIUtility.sharedUtility.getJSON(from: "fetchDictionary",
                                             headers: [:],
                                             success: { (result: [String: Any]) in
                                                //THEN: the result data type is dictionary as expected
                                                expectation.fulfill()
        }, failure: { error in
            XCTFail("Failed to fetch a dictionary. Error: \(error)")
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: StandardTestTimeout, handler: nil)
    }

    func testArrayFetch() {
        //GIVEN: Using mock data and an async method
        let expectation = self.expectation(description: "Finish requesting array")

        //WHEN: Requesting a URL that should return an array
        MainAPIUtility.sharedUtility.getJSON(from: "fetchArray",
                                             headers: [:],
                                             success: { (result: [Any]) in
                                                //THEN: the result data type is array as expected
                                                expectation.fulfill()
        }, failure: { error in
            XCTFail("Failed to fetch an array. Error: \(error)")
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: StandardTestTimeout, handler: nil)
    }

    func testArrayFail() {
        //GIVEN: Using mock data and an async method
        let expectation = self.expectation(description: "Finish requesting array")

        //WHEN: Requesting a URL that should return an array
        MainAPIUtility.sharedUtility.getJSON(from: "failArray",
                                             headers: [:],
                                             success: { (result: [Any]) in
                                                XCTFail("This should fail: mock data does not contain an array")
                                                expectation.fulfill()
        }, failure: { error in
            //THEN: the result data type is NOT array as requested, becuase mock data contains a dictionary
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: StandardTestTimeout, handler: nil)
    }

    func testDictionaryFail() {
        //GIVEN: Using mock data and an async method
        let expectation = self.expectation(description: "Finish requesting dictionary")

        //WHEN: Requesting a URL that should return a dictionary
        MainAPIUtility.sharedUtility.getJSON(from: "failDictionary",
                                             headers: [:],
                                             success: { (result: [String: Any]) in
                                                XCTFail("This should fail: mock data does not contain a dictionary")
                                                expectation.fulfill()
        }, failure: { error in
            //THEN: the result data  type is NOT dictionary as requested, becuase mock data contains an array
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: StandardTestTimeout, handler: nil)
    }
    
}
