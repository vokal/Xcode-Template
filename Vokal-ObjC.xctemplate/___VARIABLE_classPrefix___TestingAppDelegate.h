//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import <UIKit/UIKit.h>

/**
 * An application delegate which should be used for non-UI tests
 * to prevent the application from spinning up state before the 
 * tests can attach.
 *
 * More details on this approach: http://qualitycoding.org/app-delegate-for-tests/
 */

@interface ___VARIABLE_classPrefix___TestingAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

