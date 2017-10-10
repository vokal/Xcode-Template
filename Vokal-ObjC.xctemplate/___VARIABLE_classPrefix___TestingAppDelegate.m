//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

#import "___VARIABLE_classPrefix___TestingAppDelegate.h"

@implementation ___VARIABLE_classPrefix___TestingAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Create a dummy view controller
    UIViewController *testViewController = [[UIViewController alloc] init];
    testViewController.view.backgroundColor = [UIColor.redColor colorWithAlphaComponent:0.5];
    
    //Add a label to it so it's obvious what you're doing.
    UILabel *testLabel = [[UILabel alloc] init];
    testLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Note: This string doesn't need to be localized since users never see it.
    testLabel.text = @"TESTING ___PACKAGENAME___ WITHOUT UI!";
    testLabel.textColor = UIColor.whiteColor;
    [testViewController.view addSubview:testLabel];
    
    //Pin it to the middle of the view.
    [NSLayoutConstraint activateConstraints:@[
                                              [testLabel.centerXAnchor constraintEqualToAnchor:testViewController.view.centerXAnchor],
                                              [testLabel.centerYAnchor constraintEqualToAnchor:testViewController.view.centerYAnchor],
                                              ]];
    
    //Fire up the window.
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = testViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
