//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Foundation
import UIKit

//Figure out which app delegate to spin up.
let isRunningTests: Bool = NSClassFromString("XCTestCase") != nil
let isRunningUITests: Bool = NSClassFromString("KIFTestCase") != nil

let appDelegateClass: AnyClass

if (isRunningTests && !isRunningUITests) {
    appDelegateClass = TestingAppDelegate.self
} else {
    appDelegateClass = AppDelegate.self
}

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
