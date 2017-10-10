//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

@import UIKit;

#import "___VARIABLE_classPrefix___BaseTextView.h"

@interface ___VARIABLE_classPrefix___BaseTextView ()

@property (nonatomic, readwrite) BOOL oneTimeThingsAreSetUp;

@end

@implementation ___VARIABLE_classPrefix___BaseTextView

- (void)commonInit
{
    [self setupOneTimeThingsIfNeeded];
}

- (void)setupOneTimeThingsIfNeeded
{
    if (!self.oneTimeThingsAreSetUp) {
        [self setupOneTimeThings];
    }
}

- (void)setupOneTimeThings
{
    self.oneTimeThingsAreSetUp = YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

- (void)prepareForInterfaceBuilder
{
    [super prepareForInterfaceBuilder];
    [self commonInit];
}

@end
