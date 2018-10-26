//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Foundation

/**
 API for getting information about users.
 */
struct UserAPI {
    // MARK: - User Key Enums
    
    private enum POSTPath: String, APIVersionable {
        case login = "authenticate"
        case register = "user"
        case facebookLoginRegister = "user/facebook"
        case notificationRegister = "push/apn"
    }
    
    private enum GETPath: String, APIVersionable {
        case currentUser = "user"
        
        static func specificUser(userID: String) -> String {
            return  "user/" + userID
        }
    }
    
    private enum JSONKey: String {
        case email = "email"
        case password = "password"
        case userID = "id"
        case facebookID = "facebook_id"
        case token = "token"
        
        ///Aliases for things that use the same JSON key
        static let facebookToken = JSONKey.token
        static let pushNotificationToken = JSONKey.token
    }
    
    // MARK: - Login/Register
    
    /**
     Registers a new user with the given information.
     
     - parameter email:      The email to register a user for.
     - parameter password:   The password to use for the user being registered.
     - parameter success:     The closure to execute if the request succeeds.
     - parameter failure:     The closure to execute if the request fails.
     */
    static func register(withEmail email: String,
                         password: String,
                         success: @escaping APIDictionaryCompletion,
                         failure: @escaping APIFailureCompletion) {
        let parameters = [
            JSONKey.email.rawValue: email,
            JSONKey.password.rawValue: password,
            ]
        
        let registerPath = POSTPath.register.path(forVersion: .v1)
        let headers = self.requestHeaders(withAuthToken: false)
        
        MainAPIUtility
            .sharedUtility
            .postUserJSON(to: registerPath,
                          headers: headers,
                          params: parameters,
                          userEmail: email,
                          success: success,
                          failure: failure)
    }
    
    /**
     Logs in a user with the given information.
     
     - parameter email:      The email address to use to log in the user.
     - parameter password:   The password to use to log in the user.
     - parameter success:     The closure to execute if the request succeeds.
     - parameter failure:     The closure to execute if the request fails.
     */
    static func login(withEmail email: String,
                      password: String,
                      success: @escaping APIDictionaryCompletion,
                      failure: @escaping APIFailureCompletion) {
        let parameters = [
            JSONKey.email.rawValue: email,
            JSONKey.password.rawValue: password,
            ]
        
        let loginPath = POSTPath.login.path(forVersion: .v1)
        let headers = self.requestHeaders(withAuthToken: false)
        
        MainAPIUtility
            .sharedUtility
            .postUserJSON(to: loginPath,
                          headers: headers,
                          params: parameters,
                          userEmail: email,
                          success: success,
                          failure: failure)
    }
    
    /**
     Logs in or registers a user with the given Facebook information.
     
     - parameter facebookID:    The Facebook identifier of the user to login or register.
     - parameter facebookToken: The token received from the Facebook SDK
     - parameter success:     The closure to execute if the request succeeds.
     - parameter failure:     The closure to execute if the request fails.
     */
    static func facebookLoginOrRegister(withFacebookID facebookID: String,
                                        facebookToken: String,
                                        success: @escaping APIDictionaryCompletion,
                                        failure: @escaping APIFailureCompletion) {
        let parameters = [
            JSONKey.facebookID.rawValue: facebookID,
            JSONKey.facebookToken.rawValue: facebookToken,
        ]
        
        let fbLoginRegisterPath = POSTPath.facebookLoginRegister.path(forVersion: .v1)
        let headers = self.requestHeaders(withAuthToken: false)
        
        MainAPIUtility
            .sharedUtility
            .postUserJSON(to: fbLoginRegisterPath,
                          headers: headers,
                          params: parameters,
                          userEmail: facebookID,
                          success: success,
                          failure: failure)
    }
    
    // MARK: - Current User
    
    /**
     Fetches information about the current, logged in user.
     
     - parameter success:     The closure to execute if the request succeeds.
     - parameter failure:     The closure to execute if the request fails.
     */
    static func fetchCurrentUserInfo(success: @escaping APIDictionaryCompletion,
                                     failure: @escaping APIFailureCompletion) {
        let currentUserFetchPath = GETPath.currentUser.path(forVersion: .v1)
        let headers = self.requestHeaders(withAuthToken: true)
        
        MainAPIUtility
            .sharedUtility
            .getJSON(from: currentUserFetchPath,
                     headers: headers,
                     success: success,
                     failure: failure)
    }
    
    /**
     Registers the given device token received from the Apple Push Notification Service (APNS)
     server as a device for the current user.
     
     - parameter deviceToken: The device token, converted to a string
     - parameter success:     The closure to execute if the request succeeds.
     - parameter failure:     The closure to execute if the request fails.
     */
    // TODO: maybe expect an empty response here
    static func registerCurrentUserForNotifications(withToken deviceToken: String,
                                                    success: @escaping APIDictionaryCompletion,
                                                    failure: @escaping APIFailureCompletion) {
        let parameters = [
            JSONKey.pushNotificationToken.rawValue: deviceToken,
        ]
        
        let registerDeviceTokenPath = POSTPath.notificationRegister.path(forVersion: .v1)
        let headers = self.requestHeaders(withAuthToken: true)
        
        MainAPIUtility
            .sharedUtility
            .postJSON(to: registerDeviceTokenPath,
                      headers: headers,
                      params: parameters,
                      success: success,
                      failure: failure)
    }
    
    // MARK: - Other Users
    
    /**
     Fetches information about a specific user.
     
     - parameter userID:     The identifier of the user whose information you wish to retrieve.
     - parameter success:     The closure to execute if the request succeeds.
     - parameter failure:     The closure to execute if the request fails.
     */
    static func fetchUserInfo(forUserID userID: String,
                              success: @escaping APIDictionaryCompletion,
                              failure: @escaping APIFailureCompletion) {
        let userFetchPath = APIVersion.v1.versioned(path: GETPath.specificUser(userID: userID))
        let headers = self.requestHeaders(withAuthToken: true)
        
        MainAPIUtility
            .sharedUtility
            .getJSON(from: userFetchPath,
                     headers: headers,
                     success: success,
                     failure: failure)
    }
    
    // MARK: - Private Helper Methods
    
    private static func requestHeaders(withAuthToken requiresToken: Bool) -> [HTTPHeaderKey: HTTPHeaderValue] {
        return MainAPIUtility
            .sharedUtility
            .requestHeaders(withAuthToken: requiresToken)
    }
}
