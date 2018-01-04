//
//  ViewController.m
//  collectionView
//
//  Created by 王双龙 on 2017/10/16.
//  Copyright © 2017年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "ViewController.h"
#import "waterCollectionViewCell.h"
#import "WSLWaterFlowLayout.h"
#import "CollectionHeaderAndFooterView.h"
#import "UIButton+WSLTitleImage.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>
{
    WSLWaterFlowLayout * _flow;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray * array = @[@"样式1",@"样式2",@"样式3"];
    for (int i = 0; i < 3; i++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 3 * 60)/4 + i * (60 + (self.view.frame.size.width - 3 * 60)/4),24, 60, 40)];
        button.tag = i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
      }
    self.view.backgroundColor = [UIColor grayColor];
    
    
    _flow = [[WSLWaterFlowLayout alloc] init];
    _flow.delegate = self;
    _flow.flowLayoutStyle = (WSLFlowLayoutStyle)0;
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:_flow];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    //注册Item
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([waterCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"ItemID"];
    
    //注册头尾视图
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionHeaderAndFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionHeaderAndFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFooter"];
    
    [self.view addSubview:collectionView];
    
}

- (void)btnClicked:(UIButton *)button{
    
    _flow.flowLayoutStyle = (WSLFlowLayoutStyle)button.tag;
  
    for (UIView * collection in self.view.subviews) {
        if ([collection isKindOfClass: [UICollectionView class]]) {
             [(UICollectionView *)collection scrollsToTop];
            [(UICollectionView *)collection reloadData];
        }
    }
    
}

#pragma mark - WSLWaterFlowLayoutDelegate

-(CGFloat)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    
    return arc4random() % 200;
}

-(CGFloat)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout widthForItemAtIndexPath:(NSIndexPath *)indexPath itemHeight:(CGFloat)itemHeight{
    
    return arc4random() % 200;
}

- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(arc4random() % 200, 100);
}

//头视图Size
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    return CGSizeMake(40, 40);
}
//脚视图Size
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section{
    return CGSizeMake(40, 40);
}

/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 3;
}
/** 行数*/
-(CGFloat)rowCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 5;
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 10;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 10;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


#pragma mark - UICollectionView数据源

//组个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

//组内成员个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

// 返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    waterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemID" forIndexPath:indexPath];
    
//    cell.imageV.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
     cell.imageV.backgroundColor = [UIColor greenColor];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CollectionHeaderAndFooterView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
        headerView.titleLabel.text = @"头视图";
        headerView.titleLabel.backgroundColor = [UIColor orangeColor];
        return headerView;
        
    }else{
        CollectionHeaderAndFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFooter" forIndexPath:indexPath];
        footerView.titleLabel.text = @"脚视图";
        footerView.titleLabel.backgroundColor = [UIColor cyanColor];
        return footerView;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@" %@",indexPath);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
