//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

#import "___VARIABLE_classPrefix___HTTPSessionManager+MockData.h"

#import "VOKMockUrlProtocol.h"

@implementation ___VARIABLE_classPrefix___HTTPSessionManager (MockData)

+ (void)switchToMockData
{
    NSURLSessionConfiguration *sessionConfiguration = [___VARIABLE_classPrefix___HTTPSessionManager sharedManager].session.configuration;

    Class mockURLProtocol = VOKMockUrlProtocol.class;
    NSMutableArray *currentProtocolClasses = [sessionConfiguration.protocolClasses mutableCopy] ?: [NSMutableArray array];
    [currentProtocolClasses insertObject:mockURLProtocol atIndex:0];
    sessionConfiguration.protocolClasses = currentProtocolClasses;

    [___VARIABLE_classPrefix___HTTPSessionManager resetSharedManagerWithSessionConfiguration:sessionConfiguration];
}

+ (void)switchToLiveNetwork
{
    NSURLSessionConfiguration *sessionConfiguration = [___VARIABLE_classPrefix___HTTPSessionManager sharedManager].session.configuration;

    Class mockURLProtocol = VOKMockUrlProtocol.class;
    NSMutableArray *currentProtocolClasses = [sessionConfiguration.protocolClasses mutableCopy];
    [currentProtocolClasses removeObject:mockURLProtocol];
    sessionConfiguration.protocolClasses = currentProtocolClasses;

    [___VARIABLE_classPrefix___HTTPSessionManager resetSharedManagerWithSessionConfiguration:sessionConfiguration];
}

@end
