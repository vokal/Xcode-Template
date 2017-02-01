//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import UIKit

protocol ReuseIdentifierHaver: class {

    static func defaultReuseIdentifier() -> String

}

extension ReuseIdentifierHaver where Self: UIView {

    static func defaultReuseIdentifier() -> String {
        return String(describing: self)
    }

}

extension UITableViewCell: ReuseIdentifierHaver {
    // Mix-in
}

extension UITableViewHeaderFooterView: ReuseIdentifierHaver {
    // Mix-in
}

extension UICollectionReusableView: ReuseIdentifierHaver {
    // Mix-in
}

// Include this if using MapKit
//extension MKAnnotationView: ReuseIdentifierHaver {
//    // Mix-in
//}
