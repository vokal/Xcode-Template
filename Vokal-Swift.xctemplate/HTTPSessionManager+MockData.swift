//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import Foundation
@testable import ___PACKAGENAME___
import Alamofire
import VOKMockUrlProtocol

private class INeedABundle {
    /**
     Super-janky workaround to grabbing the test bundle since the bundle
     for HTTPSessionManager is the main bundle.
     */
}

extension HTTPSessionManager {
    
    /**
     Sets up the networking stack to use VOKMockURLProtocol.
     */
    static func useMockData() {
        let mockConfig = URLSessionConfiguration.default
        let mockURLProtocolClass = VOKMockUrlProtocol.self
        
        var urlProtocolsToUse: [AnyClass]
        if let currentURLProtocols = mockConfig.protocolClasses {
            urlProtocolsToUse = currentURLProtocols
        } else {
            urlProtocolsToUse = [AnyClass]()
        }
        
        urlProtocolsToUse.insert(mockURLProtocolClass, at: 0)
        mockConfig.protocolClasses = urlProtocolsToUse
        
        let testBundle = Bundle(for: INeedABundle.self)
        
        VOKMockUrlProtocol.setTest(testBundle)
        
        self.switchManagerConfiguration(to: mockConfig)
    }
    
    /**
     Sets up the networking stack to use the default NSURLSessionConfiguration.
     */
    static func useLiveData() {
        self.switchManagerConfiguration(to: URLSessionConfiguration.default)
    }
}
