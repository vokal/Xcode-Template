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
    
    static func fromStatusCode(statusCode: Int) -> NetworkError {
        switch statusCode {
        case kHTTPStatusCodeBadRequest.asInt():
            return .badRequest
        case kHTTPStatusCodeUnauthorized.asInt():
            return .unauthorized
        case kHTTPStatusCodeForbidden.asInt():
            return .forbidden
        case kHTTPStatusCodeNotFound.asInt():
            return .notFound
        case kHTTPStatusCodeConflict.asInt():
            return .conflict
        default:
            return .undefinedError(statusCode: statusCode)
        }
    }
}

///Extension to make HTTP status codes less hideous to work with in Swift.
private extension HTTPStatusCodes {
    
    /**
    - returns: The status code as an integer instead of a UInt32.
    */
    func asInt() -> Int {
        return Int(self.rawValue)
    }
}
