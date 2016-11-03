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
    
    static var AlamofireManager = Alamofire.Manager.sharedInstance
    
    static func updateManagerWithConfiguration(_ configuration: URLSessionConfiguration) {
        HTTPSessionManager.AlamofireManager = Alamofire.Manager(configuration: configuration)
    }
}
