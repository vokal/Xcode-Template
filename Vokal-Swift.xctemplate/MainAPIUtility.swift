//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import Foundation
import Alamofire

// MARK: - Completion Closures and type aliases

typealias APIDictionary = [String: Any]
typealias APIArray = [Any]

// Generic completion closure for API requests
typealias APISuccessCompletion<T> = (T) -> Void

// Failure completion closure for API requests
typealias APIFailureCompletion = (NetworkError) -> Void

// Completion closure for API requests that return a dictionary
typealias APIDictionaryCompletion = (APIDictionary) -> Void

// Completion closure for API requests that return an array
typealias APIArrayCompletion = (APIArray) -> Void

// Completion closure for API requests that return 204 No Content
typealias APIEmptyResponseCompletion = (NSNull) -> Void

// MARK: - Header enums

enum HTTPHeaderKey: String {
    case
    Authorization //Automatically "Authorization"
}

enum HTTPHeaderValue {
    case
    token(token: String)
}

// MARK: Version Handling

enum APIVersion: String {
    case
    v1 //Automatically uses "v1"
    
    /**
     Takes the passed in path and prepends a version to it. For example:
     A path of "foo" on the v1 case would return "v1/foo"
     
     - parameter path: The path to prepend the version to.
     - returns: The versioned path
     */
    func versioned(path: String) -> String {
        return self.rawValue + "/" + path
    }
}

///Protocol which should be applied to enums of API paths to apply the version to it.
protocol APIVersionable {
    associatedtype Path = String
    var rawValue: Path { get }
    init?(rawValue: Path)
    
    /**
     Takes an object conforming to APIVersionable and adds version information.
     
     - parameter version: The version to use to get the versioned path.
     - returns: The fully versioned path for this object.
     */
    func path(forVersion version: APIVersion) -> String
}

///Default protocol extension implementation.
extension APIVersionable {
    init?(_ value: Path) {
        self.init(rawValue: value)
    }
    
    func path(forVersion version: APIVersion) -> String {
        guard let rawString = self.rawValue as? String else {
            assertionFailure("This method should only be used with string enums!")
            return ""
        }
        
        return version.versioned(path: rawString)
    }
}

// MARK: - Actual API Utility

/*
 The main API utility is a chokepoint for all outgoing API calls.
 Send calls with similar success closure signatures (ex, expecting a
 Dictionary or expecting an Array) through generic methods in this class.
 
 Structs should be created which separate more granular calls by what
 they're doing - for example the UserAPI or the ResetPasswordAPI. Those
 structs can then call the more generic methods in this class.
 */
class MainAPIUtility {
    
    // MARK: - Variables
    
    /// Singleton instance
    static let sharedUtility = MainAPIUtility()
    
    let shouldDebugPrintInfo = true
    
    // MARK: - Header helper functions
    
    /**
     - parameter requireToken: true if a token is required for this request, false if not.
     
     - returns: Generic headers which should work for every request.
     */
    func requestHeaders(withAuthToken requireToken: Bool) -> [HTTPHeaderKey: HTTPHeaderValue] {
        var headerDict = [HTTPHeaderKey: HTTPHeaderValue]()
        
        if requireToken {
            if let authToken = TokenStorageHelper.getAuthorizationToken() {
                headerDict[HTTPHeaderKey.Authorization] = HTTPHeaderValue.token(token: authToken)
            } else {
                assertionFailure("This call needs a token but doesn't have one!")
            }
        }
        
        return headerDict
    }
    
    /**
     - parameter headers: Dictionary of header keys and values.
     
     - returns: A dictionary mapping the passed in header keys and values into a dictionary of
     string keys and string values.
     */
    private func headerStringDictionary(fromHeaderDictionary headers: [HTTPHeaderKey: HTTPHeaderValue]) -> [String: String] {
        
        var headerStrings = [String: String]()
        for (key, value) in headers {
            switch value {
            case .token(let token):
                headerStrings[key.rawValue] = "Bearer " + token
            }
        }
        
        return headerStrings
    }
    
    // MARK: - Methods expecting a dictionary on success
    
    func postUserJSON(to path: String,
                      headers: [HTTPHeaderKey: HTTPHeaderValue],
                      params: APIDictionary,
                      userEmail: String,
                      success: @escaping APIDictionaryCompletion,
                      failure: @escaping APIFailureCompletion) {
        
        let fullURLString = ServerEnvironment.fullURLString(for: path)
        let headerStrings = self.headerStringDictionary(fromHeaderDictionary: headers)
        
        HTTPSessionManager
            .AlamofireManager
            .request(fullURLString,
                     method: .post,
                     parameters: params,
                     encoding: JSONEncoding.default,
                     headers: headerStrings)
            .validate()
            .responseJSON { [weak self] response in
                if response.result.isSuccess {
                    if let dict = response.result.value as? APIDictionary,
                        let token = dict["token"] as? String {
                        TokenStorageHelper.store(authorizationToken: token, forEmail: userEmail)
                    }
                }
                
                self?.handle(response: response,
                             success: success,
                             failure: failure)
        }
    }
    
    func getJSON<T>(from path: String,
                    headers: [HTTPHeaderKey: HTTPHeaderValue],
                    params: APIDictionary? = nil,
                    success: @escaping APISuccessCompletion<T>,
                    failure: @escaping APIFailureCompletion) {
        
        let fullURLString = ServerEnvironment.fullURLString(for: path)
        let headerStrings = self.headerStringDictionary(fromHeaderDictionary: headers)
        
        HTTPSessionManager
            .AlamofireManager
            .request(fullURLString,
                     method: .get,
                     parameters: params,
                     encoding: URLEncoding.default,
                     headers: headerStrings)
            .validate()
            .responseJSON { [weak self] response in
                self?.handle(response: response,
                             success: success,
                             failure: failure)
        }
    }
    
    func postJSON<T>(to path: String,
                     headers: [HTTPHeaderKey: HTTPHeaderValue],
                     params: APIDictionary,
                     success: @escaping APISuccessCompletion<T>,
                     failure: @escaping APIFailureCompletion) {
        
        let fullURLString = ServerEnvironment.fullURLString(for: path)
        let headerStrings = self.headerStringDictionary(fromHeaderDictionary: headers)
        
        HTTPSessionManager
            .AlamofireManager
            .request(fullURLString,
                     method: .post,
                     parameters: params,
                     encoding: JSONEncoding.default,
                     headers: headerStrings)
            .validate()
            .responseJSON { [weak self] response in
                self?.handle(response: response,
                             success: success,
                             failure: failure)
        }
    }
    
    // MARK: Common handler for API responses

    private func handle<T>(response: DataResponse<Any>,
                           success: @escaping APISuccessCompletion<T>,
                           failure: @escaping APIFailureCompletion) {
        
        if shouldDebugPrintInfo {
            debugPrint(response)
        }
        
        switch response.result {
        case .success(let value):
            // Make sure the returned value is the type expected for the success block
            if let responseValue = value as? T {
                success(responseValue)
            } else {
                failure(NetworkError.unexpectedReturnType)
            }
        case .failure(let error):
            if let httpResponse = response.response {
                failure(NetworkError.from(statusCode: httpResponse.statusCode))
            } else {
                failure(NetworkError.otherError(error: error))
            }
        }
        
    }
}
