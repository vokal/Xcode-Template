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

let argv = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self,
                                                                      capacity: Int(CommandLine.argc))

if (isRunningTests && !isRunningUITests) {
    UIApplicationMain(CommandLine.argc, argv, nil, String(describing: TestingAppDelegate.self))
} else {
    UIApplicationMain(CommandLine.argc, argv, nil, String(describing: AppDelegate.self))
}
