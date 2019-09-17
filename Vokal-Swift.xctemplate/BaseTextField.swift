//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import UIKit

/**
 * Base class for text fields. Extend this for any custom text fields, and
 * override commonInit() to perform field setup there.
 * Make sure to call super.commonInit() in your implementation!
 */
class BaseTextField: UITextField, CommonInitializedView {
    var oneTimeThingsAreSetUp = false

    // MARK: - Setup functions which should be overridden

    func commonInit() {
        setupOneTimeThingsIfNeeded()
    }

    func setupOneTimeThings() {
        oneTimeThingsAreSetUp = true
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Interface Builder

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
}
