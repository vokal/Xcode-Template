//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import UIKit

/**
 * Base class for table view cells. Extend this for any custom cell classes, and
 * override commonInit() to perform cell setup there.
 * Make sure to call super.commonInit() in your implementation!
 */
class BaseTableViewCell: UITableViewCell, CommonInitializedView {

    var oneTimeThingsAreSetUp = false

    // MARK: - Setup functions which should be overridden

    func commonInit() {
        self.setupOneTimeThingsIfNeeded()
        // We almost never want the gray selection style. When other styles should be used, set the
        // style from code in the cell subclass.
        self.selectionStyle = .none
    }

    func setupOneTimeThings() {
        self.oneTimeThingsAreSetUp = true
    }

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }

    // MARK: - Interface Builder

    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.commonInit()
    }

}
