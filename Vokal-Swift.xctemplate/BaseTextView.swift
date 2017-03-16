//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import UIKit

/**
 * Base class for text views. Extend this for any custom text view classes, and
 * override commonInit() to perform setup there.
 * Make sure to call super.commonInit() in your implementation!
 */
class BaseTextView: UITextView, CommonInitializedView {

    var oneTimeThingsAreSetUp = false

    // MARK: - Setup functions which should be overridden

    func commonInit() {
        self.setupOneTimeThingsIfNeeded()
    }

    func setupOneTimeThings() {
        self.oneTimeThingsAreSetUp = true
    }

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
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
