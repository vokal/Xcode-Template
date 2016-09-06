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
    
    //MARK: - Keychain enums
    
    private enum KeychainKey: String {
        case
        Username = "___PACKAGENAME___.keychain.username"
    }
    
    //MARK: - Authorization methods
    
    /**
    Stores the authorization token for a given user's email in the keychain.
    
    - parameter email:     The user's email address.
    - parameter authToken: The current auth token.
    */
    static func storeAuthorizationTokenForUserEmail(email: String, authToken: String) {
        //See if the token matches existing
        if let username = getUserName() //There is a stored username
            where username != email { //It is not the email you are using right now
                //This is a differnt user, nuke the auth token.
                nukeAuthorizationToken()
        }
        
        if !KeychainWrapper.setString(email, forKey: KeychainKey.Username.rawValue) {
            DLog("Username could not be stored. Bailing out!")
            //Bail out since you'll never be able to get the token back.
            return
        }
        
        if !KeychainWrapper.setString(authToken, forKey: email) {
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
        if !KeychainWrapper.removeObjectForKey(username) {
            DLog("Auth token not removed!")
        }
        
        //Remove the username.
        if !KeychainWrapper.removeObjectForKey(KeychainKey.Username.rawValue) {
            DLog("Username not removed!")
        }
    }
    
    /**
    Retrieves the authorization token for the current user.
    
    - returns: The token, or nil if either the username or token isn't properly stored.
    */
    static func getAuthorizationToken() -> String? {
        guard let username = getUserName(),
            authToken = KeychainWrapper.stringForKey(username) else {
                return nil
        }
        
        return authToken
    }
    
    static func getUserName() -> String? {
        guard let username = KeychainWrapper.stringForKey(KeychainKey.Username.rawValue) else {
            return nil
        }
        
        return username
    }
}
