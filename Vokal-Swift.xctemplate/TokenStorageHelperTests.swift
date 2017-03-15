//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import Foundation
import XCTest
import SwiftKeychainWrapper
@testable import ___PACKAGENAME___

class TokenStorageHelperTests: XCTestCase {
    
    let testEmail = "iamatest@example.com"
    let testToken = "SomeSuperLongGibberishFromTheServer"
    
    // MARK: - Test Lifecycle
    
    override func tearDown() {
        TokenStorageHelper.nukeAuthorizationToken()
        super.tearDown()
    }
    
    private func storeAuthorizationTokenForTestUser() {
        //GIVEN: There is nothing in the keychain
        //WHEN: I store the test token for the test email
        TokenStorageHelper.store(authorizationToken: testToken, forEmail: testEmail)
        
        //THEN: The test token is returned when I get the authorization token.
        let retrieved = TokenStorageHelper.getAuthorizationToken()
        XCTAssertEqual(retrieved, testToken)
    }
    
    func testStoringAuthorizationTokenWorks() {
        storeAuthorizationTokenForTestUser()
    }
    
    func testStoringAuthorizationTokenForSecondUserNukesFirst() {
        //GIVEN: The test user's token is already stored
        storeAuthorizationTokenForTestUser()
        
        //WHEN: I add a new user's auth token
        let user = "someoneelse@example.com"
        let token = "MoarToken"
        TokenStorageHelper.store(authorizationToken: token, forEmail: user)
        
        //THEN: The new user's token is returned when I get the auth token
        let retrieved = TokenStorageHelper.getAuthorizationToken()
        XCTAssertEqual(retrieved, token)
        
        //THEN: If I access the keychain directly, there is no value for the test user.
        if let _ = KeychainWrapper.standard.string(forKey: testEmail) {
            XCTFail("There should not be a token for the test email after setting a new one!")
        }
    }
}
