//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import Foundation

/**
 API for requesting password resets then actually resetting the password.
 */
struct ResetPasswordAPI {
    
    // MARK: - Reset Password Enums
    
    private enum JSONKey: String {
        case
        RequestEmail = "email",
        UpdatedPassword = "password",
        ResetCode = "code"
    }
    
    private enum PasswordResetPath: String, APIVersionable {
        case
        Request = "password-reset/request",
        Confirm = "password-reset/confirm"
    }
    
    private static var headerDict: [HTTPHeaderKey: HTTPHeaderValue] {
        return MainAPIUtility
            .sharedUtility
            .requestHeaders(withAuthToken: false)
    }

    // MARK: - Reset Password Methods
    
    /**
     Requests a password reset for a given email address. If the email exists, this will trigger
     an email to the user with a reset request code which they can then use to reset their
     password. If the email doesn't exist, the server just smiles and nods to avoid disclosing
     what emails are actually related to accounts.
     
     - parameter email:      The email the user is requesting a password reset for.
     - parameter success:     The closure to execute if the request succeeds.
     - parameter failure:     The closure to execute if the request fails.
     */
    static func requestPasswordReset(forEmail email: String,
                                     success: @escaping APIDictionaryCompletion,
                                     failure: @escaping APIFailureCompletion) {
        let parameters = [
            JSONKey.RequestEmail.rawValue: email,
        ]
        
        let resetPasswordRequestPath = PasswordResetPath.Request.path(forVersion: .v1)
        
        MainAPIUtility
            .sharedUtility
            .postJSON(to: resetPasswordRequestPath,
                      headers: self.headerDict,
                      params: parameters,
                      success: success,
                      failure: failure)
    }
    
    /**
     Resets the password for a user who has received a password reset code via email.
     
     - parameter code:            The reset password code provided by the user.
     - parameter updatedPassword: The password the user now wants to use.
     - parameter success:     The closure to execute if the request succeeds.
     - parameter failure:     The closure to execute if the request fails.
     */
    static func resetPassword(withCode code: String,
                              updatedPassword: String,
                              success: @escaping APIDictionaryCompletion,
                              failure: @escaping APIFailureCompletion) {
        
        let parameters = [
            JSONKey.ResetCode.rawValue: code,
            JSONKey.UpdatedPassword.rawValue: updatedPassword,
        ]
        let resetPasswordPath = PasswordResetPath.Confirm.path(forVersion: .v1)
        
        MainAPIUtility
            .sharedUtility
            .postJSON(to: resetPasswordPath,
                      headers: self.headerDict,
                      params: parameters,
                      success: success,
                      failure:failure)
    }

}
