//
//  WSLWaterFlowLayout.h
//  collectionView
//
//  Created by 王双龙 on 2017/10/16.
//  Copyright © 2017年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WSLVerticalWaterFlow = 0, /** 竖向瀑布流 item等宽不等高 */
    WSLHorizontalWaterFlow = 1, /** 水平瀑布流 item等高不等宽 不支持头脚视图*/
    WSLVHWaterFlow = 2,  /** 竖向瀑布流 item等高不等宽 */
    WSLLineWaterFlow = 3 /** 线性布局 待完成，敬请期待 */
} WSLFlowLayoutStyle; //样式

@class WSLWaterFlowLayout;

@protocol WSLWaterFlowLayoutDelegate <NSObject>

/** 竖向瀑布流 item等宽不等高 */
-(CGFloat)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

/** 水平瀑布流 item等高不等宽 */
-(CGFloat)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout widthForItemAtIndexPath:(NSIndexPath *)indexPath itemHeight:(CGFloat)itemHeight;

/** 竖向瀑布流 item等高不等宽 列数、行数无用*/
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section;
/** 脚视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section;

@optional //以下都有默认值
/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout;
/** 行数*/
-(CGFloat)rowCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout;

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout;
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout;
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout;

@end

@interface WSLWaterFlowLayout : UICollectionViewLayout

/** delegate*/
@property (nonatomic, weak) id<WSLWaterFlowLayoutDelegate> delegate;
/** 瀑布流样式*/
@property (nonatomic, assign) WSLFlowLayoutStyle  flowLayoutStyle;

@end
