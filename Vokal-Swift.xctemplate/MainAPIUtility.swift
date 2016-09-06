//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import Foundation
import Alamofire

//MARK: - Completion Closures

typealias APISuccessCompletion = ([String: AnyObject]) -> Void
typealias APIFailureCompletion = (NetworkError) -> Void

//MARK: - Header enums

enum HTTPHeaderKey: String {
    case
    Authorization //Automatically "Authorization"
}

enum HTTPHeaderValue {
    case
    Token(token: String)
}

//MARK: Version Handling

enum APIVersion: String {
    case
    v1 //Automatically uses "v1"
    
    /**
    Takes the passed in path and prepends a version to it. For example:
    A path of "foo" on the v1 case would return "v1/foo"
    
    - parameter path: The path to prepend the version to.
    - returns: The versioned path
    */
    func versionedPath(path: String) -> String {
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
    func versionedPath(version: APIVersion) -> String
}

///Default protocol extension implementation.
extension APIVersionable {
    init?(_ value: Path) {
        self.init(rawValue: value)
    }
    
    func versionedPath(version: APIVersion) -> String {
        guard let rawString = self.rawValue as? String else {
            assertionFailure("This method should only be used with string enums!")
            return ""
        }
        
        return version.versionedPath(rawString)
    }
}

//MARK: - Actual API Utility

/*
The main API utility is a chokepoint for all outgoing API calls.
Send calls with similar success closure signatures (ex, expecting a 
Dictionary or expecting an Array) through generic methods in this class.

Structs should be created which separate more granular calls by what
they're doing - for example the UserAPI or the ResetPasswordAPI. Those
structs can then call the more generic methods in this class.
*/
class MainAPIUtility {
    
    //MARK: - Variables
    
    /// Singleton instance
    static let sharedUtility = MainAPIUtility()
    
    let shouldDebugPrintInfo = true
    
    //MARK: - Header helper functions
    
    /**
    - parameter requireToken: true if a token is required for this request, false if not.
    
    - returns: Generic headers which should work for every request.
    */
    func requestHeadersRequiringToken(requireToken: Bool) -> [HTTPHeaderKey: HTTPHeaderValue] {
        var headerDict = [HTTPHeaderKey: HTTPHeaderValue]()
        
        if requireToken {
            if let authToken = TokenStorageHelper.getAuthorizationToken() {
                headerDict[HTTPHeaderKey.Authorization] = HTTPHeaderValue.Token(token: authToken)
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
    private func stringDictFromHeaders(headers: [HTTPHeaderKey: HTTPHeaderValue]) -> [String: String] {
        
        var headerStrings = [String: String]()
        for (key, value) in headers {
            switch value {
            case .Token(let token):
                headerStrings[key.rawValue] = "Bearer " + token
            }
        }
        
        return headerStrings
    }
    
    //MARK: - Methods expecting a dictionary on success
    
    func postUserJSON(path: String,
        headers: [HTTPHeaderKey: HTTPHeaderValue],
        params: [String: AnyObject],
        userEmail: String,
        success: APISuccessCompletion,
        failure: APIFailureCompletion) {
            
            let fullURLString = ServerEnvironment.fullURLStringForPath(path)
            let headerStrings = stringDictFromHeaders(headers)

            HTTPSessionManager
                .AlamofireManager
                .request(.POST,
                    fullURLString,
                    encoding: .JSON,
                    parameters: params,
                    headers: headerStrings)
                .responseJSON {
                    [weak self]
                    response in
                    
                    if response.result.isSuccess {
                        if let dict = response.result.value as? [String: AnyObject],
                            token = dict["token"] as? String {
                                TokenStorageHelper.storeAuthorizationTokenForUserEmail(userEmail, authToken: token)
                        }
                    }
                    
                    self?.handleResponse(response,
                        success,
                        failure)
            }
    }
    
    func getJSON(path: String,
        headers: [HTTPHeaderKey: HTTPHeaderValue],
        params: [String: AnyObject]? = nil, //Defaults to nil
        success: APISuccessCompletion,
        failure: APIFailureCompletion) {
            
            let fullURLString = ServerEnvironment.fullURLStringForPath(path)
            let headerStrings = stringDictFromHeaders(headers)

            HTTPSessionManager
                .AlamofireManager
                .request(.GET,
                    fullURLString,
                    encoding: .URL,
                    parameters: params,
                    headers: headerStrings)
                .responseJSON {
                    [weak self]
                    response in
                    
                    self?.handleResponse(response,
                        success,
                        failure)
            }
    }
    
    func postJSON(path: String,
        headers: [HTTPHeaderKey: HTTPHeaderValue],
        params: [String: AnyObject],
        success: APISuccessCompletion,
        failure: APIFailureCompletion) {
            
            let fullURLString = ServerEnvironment.fullURLStringForPath(path)
            let headerStrings = stringDictFromHeaders(headers)

            HTTPSessionManager
                .AlamofireManager
                .request(.POST,
                    fullURLString,
                    encoding: .JSON,
                    parameters: params,
                    headers: headerStrings)
                .responseJSON {
                    [weak self]
                    response in
                    self?.handleResponse(response,
                        success,
                        failure)
            }
    }
    
    //MARK: Handler for methods expecting a dictionary on success
    
    private func handleResponse(response: Response<AnyObject, NSError>,
        _ success: APISuccessCompletion,
        _ failure: APIFailureCompletion) {
            
            if shouldDebugPrintInfo {
                debugPrint(response)
            }
            
            if let httpResponse = response.response {
                let statusCode = httpResponse.statusCode
                
                if (statusCode < 200 || statusCode >= 300) {
                    //This is actually an error.
                    let error = NetworkError.fromStatusCode(statusCode)
                    failure(error)
                    return
                }
            }
            
            if response.result.isSuccess {
                if let dict = response.result.value as? [String: AnyObject] {
                    success(dict)
                } else {
                    let error = NetworkError.UnexpectedReturnType
                    failure(error)
                }
            } else {
                var errorToFire: NetworkError
                if let error = response.result.error {
                    errorToFire = NetworkError.fromStatusCode(error.code)
                } else {
                    errorToFire = NetworkError.UnknownError
                }
                
                failure(errorToFire)
            }
    }
}
