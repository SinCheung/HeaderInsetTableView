//
//  ViewController.m
//  HeaderInsetTableView
//
//  Created by Admin on 16/5/20.
//  Copyright © 2016年 SC. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+HeaderViewInset.h"

#define PlaceholderViewHeight 110.f

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginCst;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.contentInset = UIEdgeInsetsMake(160, 0, 0, 0);
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(160, 0, 0, 0);
    _tableView.headerViewInsets = UIEdgeInsetsMake(PlaceholderViewHeight, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

#pragma mark - tableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section+1)*2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Section:%zd,Row:%zd",indexPath.section,indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Title:%zd",section];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY<=(PlaceholderViewHeight-scrollView.contentInset.top) && offsetY>=-(scrollView.contentInset.top)) {
        _topMarginCst.constant = -(offsetY+scrollView.contentInset.top)-20.f;
    } else if (offsetY>(PlaceholderViewHeight-scrollView.contentInset.top)) {
        _topMarginCst.constant = -PlaceholderViewHeight-20.f;
    } else {
        _topMarginCst.constant = -20.f;
    }
}

@end
