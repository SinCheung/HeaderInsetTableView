//
//  UITableView+HeaderViewInset.m
//  HeaderInsetTableView
//
//  See detail at "http://b2cloud.com.au/tutorial/uitableview-section-header-positions/"
//  Created by Admin on 16/5/20.
//  Copyright © 2016年 SC. All rights reserved.
//

#import "UITableView+HeaderViewInset.h"
#import <objc/runtime.h>

@implementation UITableView (HeaderViewInset)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSel = @selector(layoutSubviews);
        SEL swizlledSel = @selector(azb_layoutSubviews);
        
        Method originalMethod = class_getInstanceMethod(self, originalSel);
        Method swizzledMethod = class_getInstanceMethod(self, swizlledSel);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)azb_layoutSubviews
{
    [self azb_layoutSubviews];
    if (self.shouldLayoutHeaders) {
        [self _privateLayoutHeaderviews];
    }
}

- (void)_privateLayoutHeaderviews
{
    const NSUInteger numberOfSections = self.numberOfSections;
    const UIEdgeInsets contentInset = self.contentInset;
    const CGPoint contentOffset = self.contentOffset;
    
    const CGFloat deltaY = contentInset.top - self.headerViewInsets.top;
    const CGFloat sectionViewMinimumOriginY = contentOffset.y + deltaY;
    
    //Layout each header view
    for(NSUInteger section=0; section<numberOfSections;section++)
    {
        UIView* sectionView = [self headerViewForSection:section];
        if(sectionView == nil) continue;
        
        const CGRect sectionFrame = [self rectForSection:section];
        CGRect sectionViewFrame = sectionView.frame;
        
        if (sectionFrame.origin.y<=sectionViewMinimumOriginY)
        {
            sectionViewFrame.origin.y = sectionViewMinimumOriginY;
        } else {
            sectionViewFrame.origin.y = sectionFrame.origin.y;
        }
        
        //If it's not last section, manually 'stick' it to the below section if needed
        if(section < numberOfSections - 1)
        {
            const CGRect nextSectionFrame = [self rectForSection:section + 1];
            if(CGRectGetMaxY(sectionViewFrame) > CGRectGetMinY(nextSectionFrame))
                sectionViewFrame.origin.y = nextSectionFrame.origin.y - sectionViewFrame.size.height;
        }
        
        [sectionView setFrame:sectionViewFrame];
    }
}

#pragma associated object
- (void)setHeaderViewInsets:(UIEdgeInsets)headerViewInsets
{
    NSValue *inset = [NSValue valueWithUIEdgeInsets:headerViewInsets];
    self.shouldLayoutHeaders = !UIEdgeInsetsEqualToEdgeInsets(headerViewInsets, UIEdgeInsetsZero);
    objc_setAssociatedObject(self, @selector(headerViewInsets), inset, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (void)setShouldLayoutHeaders:(BOOL)shouldLayoutHeaders
{
    objc_setAssociatedObject(self, @selector(shouldLayoutHeaders), @(shouldLayoutHeaders), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)headerViewInsets
{
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

- (BOOL)shouldLayoutHeaders
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
