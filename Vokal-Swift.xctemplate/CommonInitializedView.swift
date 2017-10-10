//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import UIKit

/**
 * Facilitates setting up basic common initialization.
 * See BaseView for an example of implementing this protocol.
 */
protocol CommonInitializedView {

    /// Variable to track whether the one-time things are already set up.
    var oneTimeThingsAreSetUp: Bool { get }

    /**
     The common initialization function which gets called from any initializer
     or from prepareForInterfaceBuilder.

     This should be the primary override point for subclasses.
     */
    func commonInit()

    /**
     Sets up things which only need to be set up once no matter how many times
     `commonInit` is called.

     This is where programmatic autolayout and target setting should be done
     in subclasses.
     */
    func setupOneTimeThings()

    /**
     Sets up the one time things if they have not already been setup.
     */
    func setupOneTimeThingsIfNeeded()
}

// MARK: - Default implementation of protocol for view subclasses.
extension CommonInitializedView where Self: UIView {

    func setupOneTimeThingsIfNeeded() {
        if !self.oneTimeThingsAreSetUp {
            self.setupOneTimeThings()
        }
    }

    // Other methods must be implemented per class so subclasses can
    // effectively call them with a `super` call.
}
