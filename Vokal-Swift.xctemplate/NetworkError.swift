//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import Foundation
import ILGHttpConstants

enum NetworkError: ErrorType {
    case
    //Custom types
    UnexpectedReturnType,
    UnknownError,
    
    //HTTP stuff
    BadRequest,
    Unauthorized,
    Forbidden,
    NotFound,
    Conflict,
    
    //TODO: Add other cases and handling for other network errors you expect.
    UndefinedError(statusCode: Int)
    
    static func fromStatusCode(statusCode: Int) -> NetworkError {
        switch statusCode {
        case kHTTPStatusCodeBadRequest.asInt():
            return .BadRequest
        case kHTTPStatusCodeUnauthorized.asInt():
            return .Unauthorized
        case kHTTPStatusCodeForbidden.asInt():
            return .Forbidden
        case kHTTPStatusCodeNotFound.asInt():
            return .NotFound
        case kHTTPStatusCodeConflict.asInt():
            return .Conflict
        default:
            return .UndefinedError(statusCode: statusCode)
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
