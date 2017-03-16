//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import Foundation

enum ServerEnvironment {
    case
    staging,
    production
    
    //Default environment: Staging.
    static var CurrentEnvironment: ServerEnvironment {
        //Update this value in your User-Defined Build Settings for this target,
        //which will in turn update the info.plist value after a clean:
        if Bundle.main.object(forInfoDictionaryKey: "USE_PRODUCTION_SERVER") as? String == "YES" {
            return production
        }
        
        return staging
    }
    
    // MARK: - Main Application API
    
    static func fullURLString(for path: String) -> String {
        return CurrentEnvironment.apiBaseURLString + "/" + path
    }
    
    var apiBaseURLString: String {
        switch self {
        case .staging:
            return "https://falcon.vokal.io" //TODO: Change to actual staging server.
        case .production:
            return "https://api.example.com" //TODO: Change to actual prod server.
        }
    }
    
    // MARK: - Application Website
    
    var websiteBaseURLString: String {
        switch self {
        case .staging:
            return "http://auth-staging.example.com" //TODO: Change to actual staging site
        case .production:
            return "https://auth.example.com" //TODO: Change to actual prod site
        }
    }
    
    var resetPasswordURLString: String {
        return self.websiteBaseURLString + "/reset-request.html"
    }
    
    var termsURLString: String {
        return self.websiteBaseURLString + "/tos.html"
    }
    
    var privacyURLString: String {
        return self.websiteBaseURLString + "/privacy.html"
    }
}
