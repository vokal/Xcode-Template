//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

@import XCTest;

#import "___VARIABLE_classPrefix___NetworkAPIUtility.h"
#import "___VARIABLE_classPrefix___HTTPSessionManager+MockData.h"
#import "HTTPStatusCodes.h"

static NSTimeInterval const StandardTestTimeout = 3.0;

static NSString *const ValidLoginEmail = @"something@example.org";
static NSString *const NoAccountLoginEmail = @"somethingelse@example.org";
static NSString *const ValidLoginPassword = @"passw0rd";
static NSString *const InvalidLoginPassword = @"nooooope";
static NSString *const MockLoginToken = @"AFakeTokenForTesting";

@interface ___VARIABLE_classPrefix___UserAPITests : XCTestCase

@end

@implementation ___VARIABLE_classPrefix___UserAPITests

#pragma mark - Test lifecycle

+ (void)setUp
{
    [super setUp];
    
    [___VARIABLE_classPrefix___HTTPSessionManager switchToMockData];
}

+ (void)tearDown
{
    [___VARIABLE_classPrefix___HTTPSessionManager switchToLiveNetwork];
    
    [super tearDown];
}

#pragma mark - Tests

- (void)testSuccessfulEmailLogin
{
    //GIVEN: Using mock data and an async method
    XCTestExpectation *expectation = [self expectationWithDescription:@"Successful login"];
    
    //WHEN: User logs in with valid credentials
    [___VARIABLE_classPrefix___NetworkAPIUtility.sharedUtility
     loginWithEmailAddress:ValidLoginEmail
     password:ValidLoginPassword
     completion:^(NSDictionary *userInfo, NSError *error) {
         //THEN: There should be no error and a dictionary
         XCTAssertNil(error);
         XCTAssertNotNil(userInfo);
         
         //THEN: There should be a token and it should be equal to the expected value from the mock data.
         NSString *token = userInfo[@"token"];
         XCTAssertNotNil(token);
         XCTAssertEqualObjects(token, MockLoginToken);
         
         [expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:StandardTestTimeout handler:nil];
}

- (void)testWrongPasswordEmailLogin
{
    //GIVEN: Using mock data and an async method
    XCTestExpectation *expectation = [self expectationWithDescription:@"Wrong password login"];
    
    //WHEN: User logs in with the wrong password
    [___VARIABLE_classPrefix___NetworkAPIUtility.sharedUtility
     loginWithEmailAddress:ValidLoginEmail
     password:InvalidLoginPassword
     completion:^(NSDictionary *userInfo, NSError *error) {
         //THEN: There should be an error and no dictionary
         XCTAssertNotNil(error);
         XCTAssertNil(userInfo);
         
         //THEN: The error should be a 401 Unauthorized
         XCTAssertEqual(error.code, kHTTPStatusCodeUnauthorized);
         
         [expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:StandardTestTimeout handler:nil];
}

- (void)testNonexistentEmailLogin
{
    //GIVEN: Using mock data and an async method
    XCTestExpectation *expectation = [self expectationWithDescription:@"Nonexistent email login"];
    
    //WHEN: User logs in with nonexistent account
    [___VARIABLE_classPrefix___NetworkAPIUtility.sharedUtility
     loginWithEmailAddress:NoAccountLoginEmail
     password:ValidLoginPassword
     completion:^(NSDictionary *userInfo, NSError *error) {
         //THEN: There should be an error with no dictionary
         XCTAssertNotNil(error);
         XCTAssertNil(userInfo);
         
         //THEN: The error should be a 400 bad request
         XCTAssertEqual(error.code, kHTTPStatusCodeBadRequest);
         
         [expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:StandardTestTimeout handler:nil];
}

@end
