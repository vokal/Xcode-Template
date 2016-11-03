//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import Foundation

/*
This file facilitates log statements which will only print when in debug mode.

DLog will log when -D DEBUG is in the "Other Swift Flags" and do nothing when it is not.

ALog will always log with details about the file, function, and line of the caller.

Note: The message is the only required variable for any of these.
*/

/* A detailed log statement which will only print when in debug mode.

- parameter message:  The message you wish to log out.
*/
func DLog(_ message: @autoclosure () -> String,
    filename: String = #file,
    function: String = #function,
    line: Int = #line) {
        #if DEBUG
            detailedLog(message(), filename, function, line)
        #else
            //Do nothing out of debug mode
        #endif
}

/**
A detailed log statement which will always print.

- parameter message:  The message you wish to log out.
*/
func ALog(_ message: @autoclosure () -> String,
    filename: String = #file,
    function: String = #function,
    line: Int = #line) {
    detailedLog(message(), filename, function, line)
}

/**
Centralizes the detailed message formatting into a single method.

- parameter message:  The message to print
- parameter filename: The filename of the original caller.
- parameter function: The function of the original caller
- parameter line:     the line number of the original caller.
*/
private func detailedLog(_ message: String, _ filename: String, _ function: String, _ line: Int) {
    print("[\(filename.dlog_lastPathComponent()):\(line)] \(function) - \(message)")
}

private extension String {
    func dlog_lastPathComponent() -> String {
        return (self as NSString).lastPathComponent
    }
}
