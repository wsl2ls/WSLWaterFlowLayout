//
//  ViewController.m
//  collectionView
//
//  Created by 王双龙 on 2017/10/16.
//  Copyright © 2017年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "ViewController.h"
#import "VC/WSLFlowLayoutStyleOne.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSArray * vcArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"瀑布流";
    _dataSource = @[@"竖向瀑布流 item等宽不等高 支持头脚视图",@"水平瀑布流 item等高不等宽 不支持头脚视图", @"竖向瀑布流 item等高不等宽 支持头脚视图", @"特为国务院客户端原创栏目滑块样式定制-水平栅格布局  仅供学习交流"];
    _vcArray = @[@"WSLWaterFlowLayoutStyleOne", @"WSLWaterFlowLayoutStyleOne", @"WSLWaterFlowLayoutStyleOne", @"WSLWaterFlowLayoutStyleOne"];
}

#pragma mark -- UITableViewDelegate  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }
    
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    WSLWaterFlowLayoutStyleOne * flowLayout = [NSClassFromString(_vcArray[indexPath.row]) new];
    flowLayout.flowLayoutStyle = (WSLWaterFlowLayoutStyle)indexPath.row;
    
    [self.navigationController pushViewController:flowLayout animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
