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
    
    NSArray * array = @[@"样式1",@"样式2",@"样式3",@"样式4"];
    for (int i = 0; i < array.count; i++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - array.count * 60)/(array.count + 1) + i * (60 + (self.view.frame.size.width - array.count * 60)/(array.count + 1)),24, 60, 40)];
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
    
    if (_flow.flowLayoutStyle == (WSLFlowLayoutStyle)3){
        //每一个最小的正方形单元格的边长
        CGFloat  average = (self.view.frame.size.width - [self edgeInsetInWaterFlowLayout:_flow].left * 2 - 3 * [self columnMarginInWaterFlowLayout:_flow])/4.0;
        _flow.collectionView.frame = CGRectMake(0, 64, self.view.frame.size.width, average * 2 + [self rowMarginInWaterFlowLayout:_flow] + [self edgeInsetInWaterFlowLayout:_flow].top + [self edgeInsetInWaterFlowLayout:_flow].bottom);
    }else{
        _flow.collectionView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    }

    [_flow.collectionView scrollsToTop];
    [_flow.collectionView  reloadData];
    
}

#pragma mark - Help Methods
//返回样式4所需的宽高信息
- (NSArray *)proportionsForItem{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"WSLWaterFlowHorizontalGrid" ofType:@"plist"];
    NSArray * layoutInfo= [[NSArray alloc] initWithContentsOfFile:plistPath];
    return layoutInfo;
}

#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(waterFlowLayout.flowLayoutStyle == (WSLFlowLayoutStyle)0){
        return CGSizeMake(0, arc4random() % 200);
    }else if (waterFlowLayout.flowLayoutStyle == (WSLFlowLayoutStyle)1){
        return CGSizeMake(arc4random() % 200, 0);
    }else if (waterFlowLayout.flowLayoutStyle == (WSLFlowLayoutStyle)2){
         return CGSizeMake(arc4random() % 200, 100);
    }else if (waterFlowLayout.flowLayoutStyle == (WSLFlowLayoutStyle)3){
                 //每一个最小的正方形单元格的边长
        CGFloat  average = (self.view.frame.size.width - [self edgeInsetInWaterFlowLayout:waterFlowLayout].left * 2 - 3 * [self columnMarginInWaterFlowLayout:waterFlowLayout])/4.0;
        NSDictionary * proportion = [self proportionsForItem][indexPath.row];
        CGSize itemSize =  CGSizeMake(average * [proportion[@"width"] intValue]+ ([proportion[@"width"] intValue] == 2 ? [self columnMarginInWaterFlowLayout:waterFlowLayout] : 0), average * [proportion[@"height"] intValue] + ([proportion[@"height"] intValue] == 2 ? [self rowMarginInWaterFlowLayout:waterFlowLayout] : 0));
        return itemSize;
    }else{
         return CGSizeMake(0, 0);
    }
}

/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    return CGSizeMake(40, 40);
}
/** 脚视图Size */
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
    return 5;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 5;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    if (waterFlowLayout.flowLayoutStyle == (WSLFlowLayoutStyle)3){
        return UIEdgeInsetsMake(20, 20, 20, 20);
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


#pragma mark - UICollectionView数据源

//组个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_flow.flowLayoutStyle == (WSLFlowLayoutStyle)3){
        return 1;
    }
    return 3;
}

//组内成员个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_flow.flowLayoutStyle == (WSLFlowLayoutStyle)3){
        return [self proportionsForItem].count;
    }
    return 10;
}

// 返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    waterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemID" forIndexPath:indexPath];
    
    cell.label.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
//     cell.label.backgroundColor = [UIColor greenColor];
    
    cell.label.text = [NSString stringWithFormat:@"%ld - %ld",indexPath.section, indexPath.row];
    
    return cell;
    
}
//返回头脚视图
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
