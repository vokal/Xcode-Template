//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import Foundation
import Alamofire

class HTTPSessionManager {
    
    static var AlamofireManager = Alamofire.SessionManager.default
    
    static func switchManagerConfiguration(to configuration: URLSessionConfiguration) {
        HTTPSessionManager.AlamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
}
