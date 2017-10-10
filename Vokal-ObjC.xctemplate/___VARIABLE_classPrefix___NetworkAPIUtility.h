//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

#import <Foundation/Foundation.h>

#pragma mark - Completion block definitions

/// Completion block for register and login actions. userInfo is set on success, nil on failure.
typedef void(^___VARIABLE_classPrefix___UserInfoCompletionBlock)(NSDictionary *userInfo, NSError *error);

/// Completion block for API endpoints that don't return any response body.
typedef void(^___VARIABLE_classPrefix___NoResponseNetworkCompletionBlock)(NSError *error);

#pragma mark - Constants for errors

FOUNDATION_EXPORT NSString *const ___VARIABLE_classPrefix___NetworkAPIUtilityErrorDomain;

FOUNDATION_EXPORT const struct ___VARIABLE_classPrefix___NetworkAPIUtilityErrorCodes
{
    NSInteger UnexpectedResponseType;
} ___VARIABLE_classPrefix___NetworkAPIUtilityErrorCodes;

FOUNDATION_EXPORT const struct ___VARIABLE_classPrefix___NetworkAPIUtilityErrorInfoKeys
{
    __unsafe_unretained NSString *ReceivedResponseType;
} ___VARIABLE_classPrefix___NetworkAPIUtilityErrorInfoKeys;

#pragma mark - Class header

@interface ___VARIABLE_classPrefix___NetworkAPIUtility : NSObject

/**
 *  @return Singleton instance.
 */
+ (instancetype)sharedUtility;

/**
 *  Registers a new user with the given information.
 *
 *  @param email      The email to register a user for.
 *  @param password   The password to use for the user being registered.
 *  @param completion The completion block to execute after the request completes or fails.
 */
- (void)registerWithEmailAddress:(NSString *)email
                        password:(NSString *)password
                      completion:(___VARIABLE_classPrefix___UserInfoCompletionBlock)completion;

/**
 *  Logs in a user with the given information.
 *
 *  @param email      The email address to use to log in the user.
 *  @param password   The password to use to log in the user.
 *  @param completion The completion block to execute after the request completes or fails.
 */
- (void)loginWithEmailAddress:(NSString *)email
                     password:(NSString *)password
                   completion:(___VARIABLE_classPrefix___UserInfoCompletionBlock)completion;

/**
 *  Logs in or registers a user with the given Facebook information.
 *
 *  @param facebookID    The Facebook identifier of the user to login or register.
 *  @param facebookToken The token received from the Facebook SDK
 *  @param completion The completion block to execute after the request completes or fails.
 */
- (void)loginOrRegisterFacebookUserID:(NSString *)facebookID
                        facebookToken:(NSString *)facebookToken
                           completion:(___VARIABLE_classPrefix___UserInfoCompletionBlock)completion;

/**
 *  Fetches information about the current, logged in user.
 *
 *  @param completion The completion block to execute after the request completes or fails. 
 */
- (void)fetchCurrentUserWithCompletion:(___VARIABLE_classPrefix___UserInfoCompletionBlock)completion;

/**
 *  Requests a password reset for a given email address. If the email exists, this will 
 *  trigger an email to the user with a reset request code which they can then use to 
 *  reset their password. If the email doesn't exist, the server just smiles and nods
 *  to avoid disclosing what emails are actually related to accounts. 
 *
 *  @param email      The email the user is requesting a password reset for.
 *  @param completion The completion block to execute after the request completes or fails. 
 */
- (void)requestPasswordResetForEmail:(NSString *)email
                          completion:(___VARIABLE_classPrefix___NoResponseNetworkCompletionBlock)completion;

/**
 *  Resets the password for a user who has received a password reset code via email.
 *
 *  @param newPassword The password the user now wants to use.
 *  @param resetCode   The reset password code provided by the user.
 *  @param completion The completion block to execute after the request completes or fails.
 */
- (void)resetPassword:(NSString *)newPassword
            usingCode:(NSString *)resetCode
           completion:(___VARIABLE_classPrefix___NoResponseNetworkCompletionBlock)completion;

- (void)registerForNotificationsWithDeviceToken:(NSData *)deviceToken
                                     completion:(___VARIABLE_classPrefix___NoResponseNetworkCompletionBlock)completion;

/**
 * Fetches information about a specific user.
 *
 *  @param userID     The identifier of the user whose information you wish to retrieve.
 *  @param completion The completion block to execute after the request completes or fails.
 */
- (void)getUserWithID:(NSInteger)userID
           completion:(___VARIABLE_classPrefix___UserInfoCompletionBlock)completion;

@end
