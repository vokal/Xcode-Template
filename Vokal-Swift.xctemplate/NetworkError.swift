//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import Foundation
import ILGHttpConstants

enum NetworkError: Error {
    case
    //Custom types
    unexpectedReturnType,
    unknownError,
    
    //HTTP stuff
    badRequest,
    unauthorized,
    forbidden,
    notFound,
    conflict,
    
    // Undefined error, with a status code
    undefinedError(statusCode: Int),
    
    // Some other kind of error, with an associated Error to go with it
    otherError(error: Error)
    
    //TODO: Add other cases and handling for other network errors you expect.
    
    static func from(statusCode: Int) -> NetworkError {
        switch statusCode {
        case HTTPStatusCode.badRequest.asInt():
            return .badRequest
        case HTTPStatusCode.unauthorized.asInt():
            return .unauthorized
        case HTTPStatusCode.forbidden.asInt():
            return .forbidden
        case HTTPStatusCode.notFound.asInt():
            return .notFound
        case HTTPStatusCode.conflict.asInt():
            return .conflict
        default:
            return .undefinedError(statusCode: statusCode)
        }
    }
}

///Extension to make HTTP status codes less hideous to work with in Swift.
private extension HTTPStatusCode {
    
    /**
     - returns: The status code as an integer instead of a UInt32.
     */
    func asInt() -> Int {
        return Int(self.rawValue)
    }
}
