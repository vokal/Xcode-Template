//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import UIKit

/**
An application delegate which should be used for non-UI tests
to prevent the application from spinning up state before the
tests can attach.

More details on this approach: http://qualitycoding.org/app-delegate-for-tests/
And the swift aspect: http://qualitycoding.org/app-delegate-for-tests/#comment-61735
*/

class TestingAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let testViewController = UIViewController()
        testViewController.view.backgroundColor = UIColor.redColor()
            .colorWithAlphaComponent(0.5)
        
        //Add a label to it so it's obvious what you're doing.
        let testLabel = UILabel()
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //Note: This string doesn't need to be localized since users never see it.
        testLabel.text = "TESTING ___PACKAGENAME___ WITHOUT UI!"
        testLabel.textColor = .whiteColor()
        testViewController.view.addSubview(testLabel)
        
        //Pin it to the middle of the view.
        NSLayoutConstraint.activateConstraints([
            testLabel.centerXAnchor.constraintEqualToAnchor(testViewController.view.centerXAnchor),
            testLabel.centerYAnchor.constraintEqualToAnchor(testViewController.view.centerYAnchor),
            ])
        
        //Fire up the window.
        self.window = UIWindow()
        self.window?.rootViewController = testViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
