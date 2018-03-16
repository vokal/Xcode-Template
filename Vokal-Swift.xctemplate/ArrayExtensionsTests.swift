//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import XCTest

@testable import ___PACKAGENAME___

class ArrayExtensionsTests: XCTestCase {
    func testSafeSubscript() {
        let nums: [Int] = [0, 1, 2]
        
        XCTAssertNotNil(nums[safe: nums.startIndex])
        XCTAssertNil(nums[safe: nums.endIndex])
    }
}
