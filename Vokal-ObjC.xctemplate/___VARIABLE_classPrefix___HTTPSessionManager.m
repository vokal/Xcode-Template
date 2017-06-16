//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

// Un-comment this line to see full network traffic logging for debugging
// #define USE_NETWORKING_DEBUG_LOGGING 1

#import "___VARIABLE_classPrefix___HTTPSessionManager.h"

#import "HTTPStatusCodes.h"

@implementation ___VARIABLE_classPrefix___HTTPSessionManager

static ___VARIABLE_classPrefix___HTTPSessionManager *_sharedManager;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self resetSharedManagerWithSessionConfiguration:nil];
    });
    return _sharedManager;
}

+ (BOOL)useProductionEnvironment
{
    //Update this value in your User-Defined Build Settings for this target,
    //which will in turn update the info.plist value after a clean:
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"USE_PRODUCTION_SERVER"] isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)APIBaseURL
{
    /**
     * TODO: replace these URLs with the actual staging and production API URLs.
     * The URLs should NOT include the trailing slash, but may include subpaths. For
     * example, this would be a valid value:
     *   https://api-staging.example.com/api
     */
    if ([self useProductionEnvironment]) {
        // Production API
        return @"https://api.example.com";
    } else {
        // Default: Staging API
        return @"https://api-staging.example.com";
    }
}

+ (void)setAuthorizationToken:(NSString *)authToken
{
    ___VARIABLE_classPrefix___HTTPSessionManager *sessionManager = [self sharedManager];
    AFHTTPRequestSerializer *requestSerializer = (AFHTTPRequestSerializer *)sessionManager.requestSerializer;
    authToken = [@"Bearer " stringByAppendingString:authToken];
    [requestSerializer setValue:authToken forHTTPHeaderField:@"Authorization"];
}

+ (void)resetSharedManagerWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration
{
    _sharedManager = [[___VARIABLE_classPrefix___HTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self APIBaseURL]]
                                               sessionConfiguration:sessionConfiguration];
    _sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableStatusCodes = [self acceptableStatusCodes];
    _sharedManager.responseSerializer = responseSerializer;
}

+ (NSIndexSet *)acceptableStatusCodes
{
    //These status codes are among those which will be returned by the server with an error detail.
    //They must be added to the acceptable status codes or AFNetworking barfs.
    
    NSMutableIndexSet *codes = [NSMutableIndexSet indexSetWithIndex:kHTTPStatusCodeOK]; //200
    [codes addIndex:kHTTPStatusCodeCreated]; //201
    [codes addIndex:kHTTPStatusCodeNoContent]; //204 - Used to indicate succesful deletion
    [codes addIndex:kHTTPStatusCodeBadRequest]; //400
    [codes addIndex:kHTTPStatusCodeUnauthorized]; //401
    [codes addIndex:kHTTPStatusCodeForbidden]; //403
    [codes addIndex:kHTTPStatusCodeNotFound]; //404
    [codes addIndex:kHTTPStatusCodeConflict]; //409
    
    //TODO: Add any further status codes you need to actually make AFNetworking handle your expected statuses.
    
    return codes;
}

// Override the data task completion handler to add debug logging
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(void (^)(NSProgress *_Nonnull))uploadProgressBlock
                             downloadProgress:(void (^)(NSProgress *_Nonnull))downloadProgressBlock
                            completionHandler:(void (^)(NSURLResponse *_Nonnull, id _Nullable, NSError *_Nullable))completionHandler
{
    return [super dataTaskWithRequest:request
                       uploadProgress:uploadProgressBlock
                     downloadProgress:downloadProgressBlock
                    completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
#ifdef USE_NETWORKING_DEBUG_LOGGING
                        // Debug logging
                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                        DLog(@"Response:\nCode %@ %@ %@\nRequest body:\n%@\nResponse body:\n%@\nError: %@",
                             @(httpResponse.statusCode),
                             request.HTTPMethod,
                             request.URL.absoluteString,
                             [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding],
                             responseObject,
                             error);
#endif

                        if (completionHandler) {
                            completionHandler(response, responseObject, error);
                        }
                    }];
}

@end
