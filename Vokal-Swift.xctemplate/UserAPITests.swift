//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import XCTest
@testable import ___PACKAGENAME___

class UserAPITests: XCTestCase {
    
    let StandardTestTimeout = 3.0
    
    let ValidLoginEmail = "something@example.org"
    let NoAccountLoginEmail = "somethingelse@example.org"
    let ValidLoginPassword = "passw0rd"
    let InvalidLoginPassword = "nooooope"
    let MockLoginToken = "AFakeTokenForTesting"
    
    // MARK: - Test Lifecycle
    
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
    
    // MARK: - Login tests
    
    func testSuccessfulEmailLogin() {
        //GIVEN: Using mock data and an async method
        let expectation = self.expectation(description: "Successful login")
        
        //WHEN: User logs in with valid credentials
        UserAPI.login(withEmail: ValidLoginEmail,
                      password: ValidLoginPassword,
                      success: { resultDict in
                        //THEN: The call should succeed and the token should match the mock token.
                        if let token = resultDict["token"] as? String {
                            XCTAssertEqual(token, self.MockLoginToken)
                        } else {
                            XCTFail("No token returned!")
                        }
                        
                        //THEN: The token should already be stored in the keychain.
                        if let keychainToken = TokenStorageHelper.getAuthorizationToken() {
                            XCTAssertEqual(keychainToken, self.MockLoginToken)
                        } else {
                            XCTFail("Token was not stored in the keychain!")
                        }
                        
                        expectation.fulfill()
        },
                      failure: { error in
                        XCTFail("Failure block hit with error \(error)")
                        
                        expectation.fulfill()
        })

        self.waitForExpectations(timeout: StandardTestTimeout, handler: nil)
    }
    
    func testWrongPasswordEmailLogin() {
        //GIVEN: Using mock data and an async method
        let expectation = self.expectation(description: "Wrong password login")
        
        //WHEN: User logs in with the wrong password
        UserAPI.login(withEmail: ValidLoginEmail,
                      password: InvalidLoginPassword,
                      success: { _ in
                        XCTFail("This shouldn't have worked!")
                        expectation.fulfill()
        },
                      failure: { error in
                        //THEN: The call should fail with a 401 Unauthorized error
                        switch error {
                        case NetworkError.unauthorized:
                            //Do nothing, this is bueno.
                            break
                        default:
                            XCTFail("Incorrect error returned: \(error)")
                        }
                        
                        expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: StandardTestTimeout, handler: nil)
    }
    
    func testNonexistentEmailLogin() {
        //GIVEN: Using mock data and an async method
        let expectation = self.expectation(description: "Nonexistent email login")
        
        //WHEN: User logs in with nonexistent account
        UserAPI.login(withEmail: NoAccountLoginEmail,
                      password: ValidLoginPassword,
                      success: { _ in
                        XCTFail("This shouldn't have worked!")
                        expectation.fulfill()
        },
                      failure: { error in
                        //THEN: The call should fail with a 400 bad request error
                        switch error {
                        case NetworkError.badRequest:
                            //Do nothing, this is bueno.
                            break
                        default:
                            XCTFail("Incorrect error returned: \(error)")
                        }
                        
                        expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: StandardTestTimeout, handler: nil)
    }
}
