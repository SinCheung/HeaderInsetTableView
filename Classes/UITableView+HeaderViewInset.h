//
//  UITableView+HeaderViewInset.h
//  HeaderInsetTableView
//
//  See detail at "http://b2cloud.com.au/tutorial/uitableview-section-header-positions/"
//  Created by Admin on 16/5/20.
//  Copyright © 2016年 SC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (HeaderViewInset)
/**
 *  headerView`s inset,you should set it when you setted contentInset value.
 */
@property (nonatomic, assign) UIEdgeInsets headerViewInsets;
@end
