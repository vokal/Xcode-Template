//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

@import Foundation;

@protocol ___VARIABLE_classPrefix___CommonInitializedView <NSObject>

@property (nonatomic, readonly) BOOL oneTimeThingsAreSetUp;

/**
 * The common initialization function which gets called from any initializer
 * or from prepareForInterfaceBuilder.
 *
 * This should be the primary override point for subclasses.
 */
- (void)commonInit;


/**
 * Sets up things which only need to be set up once no matter how many times
 * `commonInit` is called.
 *
 * This is where programmatic autolayout and target setting should be done
 * in subclasses.
 */
- (void)setupOneTimeThings;

/**
 * Sets up the one time things if they have not already been setup.
 */
- (void)setupOneTimeThingsIfNeeded;

@end
