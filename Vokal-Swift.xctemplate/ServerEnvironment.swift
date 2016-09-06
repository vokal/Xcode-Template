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
    Staging,
    Production
    
    //Default environment: Staging.
    static var CurrentEnvironment: ServerEnvironment {
        //Update this value in your User-Defined Build Settings for this target,
        //which will in turn update the info.plist value after a clean:
        if NSBundle.mainBundle().objectForInfoDictionaryKey("USE_PRODUCTION_SERVER") as? String == "YES" {
            return Production
        }
        
        return Staging
    }
    
    //MARK: Main Application API
    
    static func fullURLStringForPath(path: String) -> String {
        return CurrentEnvironment.apiBaseURLString + "/" + path
    }
    
    var apiBaseURLString: String {
        switch self {
        case .Staging:
            return "https://falcon.vokal.io" //TODO: Change to actual staging server.
        case .Production:
            return "https://api.example.com" //TODO: Change to actual prod server.       
        }
    }
    
    //MARK: Application Website
    
    var websiteBaseURLString: String {
        switch self {
        case .Staging:
            return "http://auth-staging.example.com" //TODO: Change to actual staging site
        case .Production:
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
