//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import "AFNetworking.h"

@interface ___VARIABLE_classPrefix___HTTPSessionManager : AFHTTPSessionManager

/**
 * Get the singleton object that's used for by ___VARIABLE_classPrefix___NetworkAPIUtility
 *
 * @return Shared manager object
 */
+ (instancetype)sharedManager;

/// Whether to use the production environment
@property (nonatomic, class, readonly) BOOL useProductionEnvironment;

/**
 * Update the authorization token that's included with all network calls. Pass
 * nil when the user logs out, to clear the token.
 *
 * @param authToken New auth token, or nil on logout
 */
+ (void)setAuthorizationToken:(NSString *)authToken;

/**
 * Replace the sharedManager with a new copy that uses the given session
 * configuration. Pass nil to use the default session configuration.
 *
 * @param sessionConfiguration New session configuration, or nil for default
 */
+ (void)resetSharedManagerWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration;

@end
