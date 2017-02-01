//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import UIKit

/**
 * Mix-in protocol for cells and views that make use of a reuse identifier. The default implementation
 * of defaultReuseIdentifier() returns the class name. Add this protocol to a class to use that
 * default functionality.
 */
protocol ReuseIdentifiable: class {

    static func defaultReuseIdentifier() -> String

}

extension ReuseIdentifiable where Self: UIView {

    static func defaultReuseIdentifier() -> String {
        return String(describing: self)
    }

}

/// Provide a default reuse identifier for table view cells
extension UITableViewCell: ReuseIdentifiable {
    // Mix-in
}

/// Provide a default reuse identifier for table view headers and footers
extension UITableViewHeaderFooterView: ReuseIdentifiable {
    // Mix-in
}

/// Provide a default reuse identifier for collection view cells
extension UICollectionReusableView: ReuseIdentifiable {
    // Mix-in
}

// Include this if using MapKit
/// Provide a default reuse identifier for map annotation views
//extension MKAnnotationView: ReuseIdentifiable {
//    // Mix-in
//}
