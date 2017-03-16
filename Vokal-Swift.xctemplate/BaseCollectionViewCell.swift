//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import UIKit

/**
 * Base class for collection view cells. Extend this for any custom cell classes, and
 * override commonInit() to perform cell setup there.
 * Make sure to call super.commonInit() in your implementation!
 */
class BaseCollectionViewCell: UICollectionViewCell, CommonInitializedView {
    
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
