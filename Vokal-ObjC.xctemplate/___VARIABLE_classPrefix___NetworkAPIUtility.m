//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

#import "___VARIABLE_classPrefix___NetworkAPIUtility.h"

#import "___VARIABLE_classPrefix___HTTPSessionManager.h"

#pragma mark - API paths

#define APIPathComponentBase @"v1/"
static NSString *const APIPathUserLogin = APIPathComponentBase @"authenticate";

#define APIPathComponentUser APIPathComponentBase @"user"
static NSString *const APIPathUserRegister = APIPathComponentUser;
static NSString *const APIPathCurrentUserFetch = APIPathComponentUser;
static NSString *const APIPathFormatSpecificUserFetch = APIPathComponentUser @"/%@"; // v1/user/:id
static NSString *const APIPathFacebookLoginRegister = APIPathComponentUser @"/facebook";

#define APIPathComponentPasswordReset APIPathComponentBase @"password-reset/"
static NSString *const APIPathRequestPasswordReset = APIPathComponentPasswordReset @"request";
static NSString *const APIPathResetPassword = APIPathComponentPasswordReset @"confirm";

#define APIPathComponentPush APIPathComponentBase @"push/"
static NSString *const APIPathNotificationRegister = APIPathComponentPush @"apn";

#pragma mark - API keys

static NSString *const APIKeyEmail = @"email";
static NSString *const APIKeyPassword = @"password";
static NSString *const APIKeyUserID = @"id";
static NSString *const APIKeyUserAuthToken = @"token";
static NSString *const APIKeyFacebookID = @"facebook_id";
static NSString *const APIKeyFacebookToken = @"token";
static NSString *const APIKeyPushNotificationToken = @"token";
static NSString *const APIKeyPasswordResetCode = @"code";
static NSString *const APIKeyErrorDetail = @"detail";

#pragma mark - Constants for errors

NSString *const ___VARIABLE_classPrefix___NetworkAPIUtilityErrorDomain = @"___VARIABLE_classPrefix___NetworkAPIUtilityErrorDomain";

const struct ___VARIABLE_classPrefix___NetworkAPIUtilityErrorCodes ___VARIABLE_classPrefix___NetworkAPIUtilityErrorCodes = {
    .UnexpectedResponseType = 300001,
};

const struct ___VARIABLE_classPrefix___NetworkAPIUtilityErrorInfoKeys ___VARIABLE_classPrefix___NetworkAPIUtilityErrorInfoKeys = {
    .ReceivedResponseType = @"Received response type",
};

#pragma mark - Class implementation

@implementation ___VARIABLE_classPrefix___NetworkAPIUtility

+ (instancetype)sharedUtility
{
    static ___VARIABLE_classPrefix___NetworkAPIUtility *_sharedUtility = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUtility = [___VARIABLE_classPrefix___NetworkAPIUtility new];
    });
    return _sharedUtility;
}

- (void)registerWithEmailAddress:(NSString *)email
                        password:(NSString *)password
                      completion:(___VARIABLE_classPrefix___UserInfoCompletionBlock)completion
{
    NSParameterAssert(email);
    NSParameterAssert(password);
    NSDictionary *userInfo = @{
                               APIKeyEmail: email ?: @"",
                               APIKeyPassword: password ?: @"",
                               };
    [self executeLoginOrRegisterOnPath:APIPathUserRegister
                           withDetails:userInfo
                            completion:completion];
}

- (void)loginWithEmailAddress:(NSString *)email
                     password:(NSString *)password
                   completion:(___VARIABLE_classPrefix___UserInfoCompletionBlock)completion
{
    NSParameterAssert(email);
    NSParameterAssert(password);
    NSDictionary *userInfo = @{
                               APIKeyEmail: email ?: @"",
                               APIKeyPassword: password ?: @"",
                               };
    [self executeLoginOrRegisterOnPath:APIPathUserLogin
                           withDetails:userInfo
                            completion:completion];
}

- (void)loginOrRegisterFacebookUserID:(NSString *)facebookID
                        facebookToken:(NSString *)facebookToken
                           completion:(___VARIABLE_classPrefix___UserInfoCompletionBlock)completion
{
    NSParameterAssert(facebookID);
    NSParameterAssert(facebookToken);
    NSDictionary *userInfo = @{
                               APIKeyFacebookID: facebookID ?: @"",
                               APIKeyFacebookToken: facebookToken ?: @"",
                               };
    [self executeLoginOrRegisterOnPath:APIPathFacebookLoginRegister
                           withDetails:userInfo
                            completion:completion];
}

- (void)fetchCurrentUserWithCompletion:(___VARIABLE_classPrefix___UserInfoCompletionBlock)completion
{
    typeof(self) __weak weakSelf = self;
    [___VARIABLE_classPrefix___HTTPSessionManager.sharedManager
     GET:APIPathCurrentUserFetch
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
         if ([responseObject isKindOfClass:[NSDictionary class]]) {
             [weakSelf handleUserInfoSuccessWithResponse:(NSHTTPURLResponse *)task.response
                                                  object:(NSDictionary *)responseObject
                                              completion:completion];
         } else {
             NSError *unexpectedResponse = [weakSelf unexpectedResponseTypeErrorForClass:responseObject.class];
             [weakSelf handleUserInfoError:unexpectedResponse withCompletion:completion];
         }
     }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
         [weakSelf handleUserInfoError:error withCompletion:completion];
     }];
}

- (void)requestPasswordResetForEmail:(NSString *)email
                          completion:(___VARIABLE_classPrefix___NoResponseNetworkCompletionBlock)completion
{
    NSParameterAssert(email);
    
    NSDictionary *parameters = @{ APIKeyEmail: email ?: @"" };
    
    typeof(self) __weak weakSelf = self;
    [___VARIABLE_classPrefix___HTTPSessionManager.sharedManager
     POST:APIPathRequestPasswordReset
     parameters:parameters
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
         [weakSelf handleNoResponseSuccessWithResponse:(NSHTTPURLResponse *)task.response
                                                object:(NSDictionary *)responseObject
                                            completion:completion];
     }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
         [weakSelf handleNoResponseError:error withCompletion:completion];
     }];
}

- (void)resetPassword:(NSString *)newPassword
            usingCode:(NSString *)resetCode
           completion:(___VARIABLE_classPrefix___NoResponseNetworkCompletionBlock)completion
{
    NSParameterAssert(newPassword);
    NSParameterAssert(resetCode);
    
    NSDictionary *parameters = @{
                                 APIKeyPassword: newPassword ?: @"",
                                 APIKeyPasswordResetCode: resetCode ?: @"",
                                 };
    
    typeof(self) __weak weakSelf = self;
    [___VARIABLE_classPrefix___HTTPSessionManager.sharedManager
     POST:APIPathResetPassword
     parameters:parameters
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
         [weakSelf handleNoResponseSuccessWithResponse:(NSHTTPURLResponse *)task.response
                                                object:(NSDictionary *)responseObject
                                            completion:completion];
     }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
         [weakSelf handleNoResponseError:error withCompletion:completion];
     }];
}

- (void)registerForNotificationsWithDeviceToken:(NSData *)deviceToken
                                     completion:(___VARIABLE_classPrefix___NoResponseNetworkCompletionBlock)completion
{
    NSParameterAssert(deviceToken);

    // Convert NSData device token to NSString token
    NSString *stringToken = [deviceToken.description stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    stringToken = [stringToken stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSDictionary *parameters = @{ APIKeyPushNotificationToken: stringToken ?: @"", };

    typeof(self) __weak weakSelf = self;
    [___VARIABLE_classPrefix___HTTPSessionManager.sharedManager
     POST:APIPathNotificationRegister
     parameters:parameters
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
         [weakSelf handleNoResponseSuccessWithResponse:(NSHTTPURLResponse *)task.response
                                                object:(NSDictionary *)responseObject
                                            completion:completion];
     }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
         [weakSelf handleNoResponseError:error withCompletion:completion];
     }];
}

- (void)getUserWithID:(NSInteger)userID
           completion:(___VARIABLE_classPrefix___UserInfoCompletionBlock)completion
{
    NSParameterAssert(userID > 0);
    NSString *userFetchPath = [NSString stringWithFormat:APIPathFormatSpecificUserFetch, @(userID)];

    typeof(self) __weak weakSelf = self;
    [___VARIABLE_classPrefix___HTTPSessionManager.sharedManager
     GET:userFetchPath
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
         if ([responseObject isKindOfClass:NSDictionary.class]) {
             [weakSelf handleUserInfoSuccessWithResponse:(NSHTTPURLResponse *)task.response
                                                  object:(NSDictionary *)responseObject
                                              completion:completion];
         } else {
             NSError *unexpectedResponse = [weakSelf unexpectedResponseTypeErrorForClass:responseObject.class];
             [weakSelf handleUserInfoError:unexpectedResponse withCompletion:completion];
         }
     }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
         [weakSelf handleUserInfoError:error withCompletion:completion];
     }];
}

#pragma mark - Private helpers

/**
 * Since the register and login endpoints take (roughly) the same parameters and
 * return the same kind of response, and in both cases the authorization token
 * needs to be saved, this helper method handles both actions by taking the path
 * against which the operation should be executed.
 */
- (void)executeLoginOrRegisterOnPath:(NSString *)path
                         withDetails:(NSDictionary *)loginDetails
                          completion:(___VARIABLE_classPrefix___UserInfoCompletionBlock)completion
{
    NSParameterAssert(path);
    NSParameterAssert(loginDetails);

    typeof(self) __weak weakSelf = self;
    [___VARIABLE_classPrefix___HTTPSessionManager.sharedManager
     POST:path
     parameters:loginDetails
     progress:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
         if ([responseObject isKindOfClass:[NSDictionary class]]) {
             [weakSelf handleUserInfoSuccessWithResponse:(NSHTTPURLResponse *)task.response
                                                  object:(NSDictionary *)responseObject
                                              completion:completion];
         } else {
             NSError *unexpectedResponse = [weakSelf unexpectedResponseTypeErrorForClass:responseObject.class];
             [weakSelf handleUserInfoError:unexpectedResponse withCompletion:completion];
         }
     }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
         [weakSelf handleUserInfoError:error withCompletion:completion];
     }];
}

#pragma mark - Response handling
#pragma mark User Info Completion

- (void)handleUserInfoSuccessWithResponse:(NSHTTPURLResponse *)response
                                   object:(NSDictionary *)responseDictionary
                               completion:(___VARIABLE_classPrefix___UserInfoCompletionBlock)completion
{
    NSError *errorFromResponse = [self errorFromResponse:response withDictionary:responseDictionary];
    if (errorFromResponse) {
        //Fire the completion and bail out.
        [self handleUserInfoError:errorFromResponse withCompletion:completion];
        return;
    }
    
    // Store the authorization token for future API calls
    NSString *authorizationToken = responseDictionary[APIKeyUserAuthToken];
    if (authorizationToken) {
        [___VARIABLE_classPrefix___HTTPSessionManager setAuthorizationToken:authorizationToken];
    }
    
    if (completion) {
        completion(responseDictionary, nil);
    }
}

- (void)handleUserInfoError:(NSError *)error withCompletion:(___VARIABLE_classPrefix___UserInfoCompletionBlock)completion
{
    if (completion) {
        completion(nil, error);
    }
}

#pragma mark No Response Completion

- (void)handleNoResponseSuccessWithResponse:(NSHTTPURLResponse *)response
                                     object:(NSDictionary *)responseDictionary
                                 completion:(___VARIABLE_classPrefix___NoResponseNetworkCompletionBlock)completion
{
    NSError *errorFromResponse = [self errorFromResponse:response withDictionary:responseDictionary];
    if (errorFromResponse) {
        //Fire the completion and bail out.
        [self handleNoResponseError:errorFromResponse withCompletion:completion];
        return;
    }
    
    //Otherwise, we're good.
    if (completion) {
        completion(nil);
    }
}

- (void)handleNoResponseError:(NSError *)error withCompletion:(___VARIABLE_classPrefix___NoResponseNetworkCompletionBlock)completion
{
    if (completion) {
        completion(error);
    }
}

#pragma mark - Error creation

- (NSError *)unexpectedResponseTypeErrorForClass:(Class)class
{
    return [NSError errorWithDomain:___VARIABLE_classPrefix___NetworkAPIUtilityErrorDomain
                               code:___VARIABLE_classPrefix___NetworkAPIUtilityErrorCodes.UnexpectedResponseType
                           userInfo:@{ ___VARIABLE_classPrefix___NetworkAPIUtilityErrorInfoKeys.ReceivedResponseType: NSStringFromClass(class) ?: @"", }];
}

- (NSError *)expectedErrorWithCode:(NSInteger)code message:(NSString *)message
{
    return [NSError errorWithDomain:___VARIABLE_classPrefix___NetworkAPIUtilityErrorDomain
                               code:code
                           userInfo:@{ NSLocalizedDescriptionKey: message ?: @"", }];
}

- (NSError *)errorFromResponse:(NSHTTPURLResponse *)response withDictionary:(NSDictionary *)responseDictionary
{
    NSInteger statusCode = response.statusCode;
    if (statusCode < 200 || statusCode >= 300) {
        //This is actually an error.
        NSString *message = responseDictionary[APIKeyErrorDetail];
        NSError *error = [self expectedErrorWithCode:statusCode message:message];
        return error;
    } else {
        return nil;
    }
}

@end
