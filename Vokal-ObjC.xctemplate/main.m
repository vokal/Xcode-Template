//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

#import <UIKit/UIKit.h>

#import "___VARIABLE_classPrefix___AppDelegate.h"
#import "___VARIABLE_classPrefix___TestingAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        //Figure out what app delegate to spin up.
        BOOL isRunningTests = NSClassFromString(@"XCTestCase") != nil;
        
        if (isRunningTests) {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass(___VARIABLE_classPrefix___TestingAppDelegate.class));
        } else {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass(___VARIABLE_classPrefix___AppDelegate.class));
        }        
    }
}
