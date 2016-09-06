//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import <Foundation/Foundation.h>

/**
 * A helper for setting up Core Data with Vokoder. This should usually be
 * set up to run as early as possible, in your app delegate's willFinishLaunching:
 * withOptions: method.
 *
 * NOTE: If you're using a Testing App Delegate, you should also have this helper
 * run `setupCoreDataForTesting` in that file as well.
 */
@interface ___VARIABLE_classPrefix___CoreDataUtility : NSObject

/**
 * Sets up the maps to use an in-memory store for testing.
 */
+ (void)setupCoreDataForTesting;

/**
 * Standard setup method.
 */
+ (void)setupCoreData;

/**
 *  Nukes the existing store and sets it back up as a clean store.
 */
+ (void)nukeAndResetCoreData;

/**
 *  Nukes the existing store and sets it back up as a clean store for testing.
 */
+ (void)nukeAndResetCoreDataForTesting;

@end
