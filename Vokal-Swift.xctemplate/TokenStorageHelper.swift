//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import Foundation
import SwiftKeychainWrapper

/**
 Facilitates the storage of a single user's credentials in the keychain.
 */
struct TokenStorageHelper {
    
    // MARK: - Keychain enums
    
    private enum KeychainKey: String {
        case
        Username = "___PACKAGENAME___.keychain.username"
    }
    
    // MARK: - Authorization methods
    
    /**
     Stores the authorization token for a given user's email in the keychain.
     
     - parameter email:     The user's email address.
     - parameter authToken: The current auth token.
     */
    static func store(authorizationToken: String, forEmail email: String) {
        // See if the token matches existing:
        // There is a stored username, and it is not the email you are using right now
        if let username = getUserName(), username != email {
            //This is a differnt user, nuke the auth token.
            nukeAuthorizationToken()
        }
        
        if !KeychainWrapper.standard.set(email, forKey: KeychainKey.Username.rawValue) {
            DLog("Username could not be stored. Bailing out!")
            //Bail out since you'll never be able to get the token back.
            return
        }
        
        if !KeychainWrapper.standard.set(authorizationToken, forKey: email) {
            DLog("Auth token could not be stored!")
        }
    }
    
    /**
     Removes both the authorization token and the current stored username, if they exist.
     */
    static func nukeAuthorizationToken() {
        guard let username = getUserName() else {
            //Nothin' to do, nowhere to go.
            return
        }
        
        //Remove the auth token
        if !KeychainWrapper.standard.removeObject(forKey: username) {
            DLog("Auth token not removed!")
        }
        
        //Remove the username.
        if !KeychainWrapper.standard.removeObject(forKey: KeychainKey.Username.rawValue) {
            DLog("Username not removed!")
        }
    }
    
    /**
     Retrieves the authorization token for the current user.
     
     - returns: The token, or nil if either the username or token isn't properly stored.
     */
    static func getAuthorizationToken() -> String? {
        guard let username = getUserName(),
            let authToken = KeychainWrapper.standard.string(forKey: username) else {
                return nil
        }
        
        return authToken
    }
    
    static func getUserName() -> String? {
        guard let username = KeychainWrapper.standard.string(forKey: KeychainKey.Username.rawValue) else {
            return nil
        }
        
        return username
    }
}
