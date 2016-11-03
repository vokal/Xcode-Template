//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import Foundation

/**
API for getting information about users.
*/
struct UserAPI {
    
    //MARK: - User Key Enums
    
    //MARK: - User Key Enums
    
    private enum POSTPath: String, APIVersionable {
        case
        Login = "authenticate",
        Register = "user",
        FacebookLoginRegister = "user/facebook",
        NotificationRegister = "push/apn"
    }
    
    private enum GETPath: String, APIVersionable {
        case
        CurrentUser = "user"
        
        static func specificUser(_ userID: String) -> String {
            return  "user/" + userID
        }
    }
    
    private enum JSONKey: String {
        case
        Email = "email",
        Password = "password",
        UserID = "id",
        FacebookID = "facebook_id",
        Token = "token"
        
        ///Aliases for things that use the same JSON key
        static let FacebookToken = JSONKey.Token
        static let PushNotificationToken = JSONKey.Token
    }
    
    //MARK: - Login/Register
    
    /**
    Registers a new user with the given information.
    
    - parameter email:      The email to register a user for.
    - parameter password:   The password to use for the user being registered.
    - parameter success:     The closure to execute if the request succeeds.
    - parameter failure:     The closure to execute if the request fails.
    */
    static func registerWithEmail(_ email: String,
        password: String,
        success: @escaping APISuccessCompletion,
        failure: @escaping APIFailureCompletion) {
            let parameters = [
                JSONKey.Email.rawValue: email,
                JSONKey.Password.rawValue: password
            ]
            
            let registerPath = POSTPath.Register.versionedPath(.v1)
            let headers = requestHeadersRequiringToken(false)
            
            MainAPIUtility
                .sharedUtility
                .postUserJSON(registerPath,
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
    static func loginWithEmail(_ email: String,
        password: String,
        success: @escaping APISuccessCompletion,
        failure: @escaping APIFailureCompletion) {
            let parameters = [
                JSONKey.Email.rawValue: email,
                JSONKey.Password.rawValue: password
            ]
            
            let loginPath = POSTPath.Login.versionedPath(.v1)
            let headers = requestHeadersRequiringToken(false)
            
            MainAPIUtility
                .sharedUtility
                .postUserJSON(loginPath,
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
    static func loginOrRegisterWithFacebookUserID(_ facebookID: String,
        facebookToken: String,
        success: @escaping APISuccessCompletion,
        failure: @escaping APIFailureCompletion) {
            
            let parameters = [
                JSONKey.FacebookID.rawValue: facebookID,
                JSONKey.FacebookToken.rawValue: facebookToken
            ]
            
            let fbLoginRegisterPath = POSTPath.FacebookLoginRegister.versionedPath(.v1)
            let headers = requestHeadersRequiringToken(false)
            
            MainAPIUtility
                .sharedUtility
                .postUserJSON(fbLoginRegisterPath,
                    headers: headers,
                    params: parameters,
                    userEmail: facebookID,
                    success: success,
                    failure: failure)
    }
    
    //MARK: - Current User
    
    /**
    Fetches information about the current, logged in user.
    
    - parameter success:     The closure to execute if the request succeeds.
    - parameter failure:     The closure to execute if the request fails.
    */
    static func fetchCurrentUserInfo(_ success: @escaping APISuccessCompletion, failure: @escaping APIFailureCompletion) {
        let currentUserFetchPath = GETPath.CurrentUser.versionedPath(.v1)
        let headers = requestHeadersRequiringToken(true)
        
        MainAPIUtility
            .sharedUtility
            .getJSON(currentUserFetchPath,
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
    static func registerCurrentUserForNotificationsWithDeviceToken(_ deviceToken: String,
        success: @escaping APISuccessCompletion,
        failure: @escaping APIFailureCompletion) {
            
            let parameters = [
                JSONKey.PushNotificationToken.rawValue: deviceToken
            ]
            
            let registerDeviceTokenPath = POSTPath.NotificationRegister.versionedPath(.v1)
            let headers = requestHeadersRequiringToken(true)
            
            MainAPIUtility
                .sharedUtility
                .postJSON(registerDeviceTokenPath,
                    headers: headers,
                    params: parameters,
                    success: success,
                    failure: failure)
    }
    
    //MARK: - Other Users
    
    /**
    Fetches information about a specific user.
    
    - parameter userID:     The identifier of the user whose information you wish to retrieve.
    - parameter success:     The closure to execute if the request succeeds.
    - parameter failure:     The closure to execute if the request fails.
    */
    static func fetchInfoForUser(_ userID: String,
        success: @escaping APISuccessCompletion,
        failure: @escaping APIFailureCompletion) {
            let userFetchPath = APIVersion.v1.versionedPath(GETPath.specificUser(userID))
            let headers = requestHeadersRequiringToken(true)
            
            MainAPIUtility
                .sharedUtility
                .getJSON(userFetchPath,
                    headers: headers,
                    success: success,
                    failure: failure)
    }
    
    //MARK: - Private Helper Methods
    
    private static func requestHeadersRequiringToken(_ requiresToken: Bool) -> [HTTPHeaderKey: HTTPHeaderValue]  {
        return MainAPIUtility
            .sharedUtility
            .requestHeadersRequiringToken(requiresToken)
    }
}
