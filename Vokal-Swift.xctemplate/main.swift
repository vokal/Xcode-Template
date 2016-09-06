//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import Foundation
import UIKit

//Figure out which app delegate to spin up.
let isRunningTests: Bool = NSClassFromString("XCTestCase") != nil
let isRunningUITests: Bool = NSClassFromString("KIFTestCase") != nil

if (isRunningTests && !isRunningUITests) {
    UIApplicationMain(Process.argc, Process.unsafeArgv, nil, NSStringFromClass(TestingAppDelegate))
} else {
    UIApplicationMain(Process.argc, Process.unsafeArgv, nil, NSStringFromClass(AppDelegate))
}
