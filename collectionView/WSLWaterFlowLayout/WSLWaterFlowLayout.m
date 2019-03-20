//
//  WSLWaterFlowLayout.m
//  collectionView
//
//  Created by 王双龙 on 2017/10/16.
//  Copyright © 2017年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "WSLWaterFlowLayout.h"

/** 默认的列数*/
static const NSInteger WSLDefaultColumeCount = 2;
/** 默认的行数*/
static const NSInteger WSLDefaultRowCount = 5;

/** 每一列之间的间距*/
static const NSInteger WSLDefaultColumeMargin = 10;
/** 每一行之间的间距*/
static const CGFloat WSLDefaultRowMargin = 10;
/** 边缘之间的间距*/
static const UIEdgeInsets WSLDefaultEdgeInset = {10, 10, 10, 10};

///** 每一行之间的间距*/
//static const CGSize WSLDefaultHeaderSize = CGSizeMake(0, 66);
///** 每一行之间的间距*/
//static const CGSize WSLDefaultFooterSize = CGSizeMake(0, 66);


@interface WSLWaterFlowLayout ()

/** 存放所有cell的布局属性*/
@property (strong, nonatomic) NSMutableArray *attrsArray;

/** 存放每一列的最大y值*/
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 存放每一行的最大x值*/
@property (nonatomic, strong) NSMutableArray *rowWidths;

/** 内容的高度*/
@property (nonatomic, assign) CGFloat maxColumnHeight;
/** 内容的宽度*/
@property (nonatomic, assign) CGFloat maxRowWidth;

/** 列数*/
-(NSInteger)columnCount;
/** 行数*/
-(NSInteger)rowCount;

/** 每一行之间的间距*/
-(CGFloat)rowMargin;
/** 每一列之间的间距*/
-(CGFloat)columnMargin;
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsets;

@end

@implementation WSLWaterFlowLayout

#pragma mark item属性配置

-(CGFloat)columnMargin {
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterFlowLayout:)]) {
        return [self.delegate columnMarginInWaterFlowLayout:self];
    } else {
        return  WSLDefaultColumeMargin;
    }
}

-(CGFloat)rowMargin {
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterFlowLayout:)]) {
        return [self.delegate rowMarginInWaterFlowLayout:self];
    } else {
        return WSLDefaultRowMargin;
    }
}

-(NSInteger)columnCount {
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterFlowLayout:)]) {
        return [self.delegate columnCountInWaterFlowLayout:self];
    } else {
        return  WSLDefaultColumeCount;
    }
}

-(NSInteger)rowCount{
    
    if ([self.delegate respondsToSelector:@selector(rowCountInWaterFlowLayout:)]) {
        return [self.delegate rowCountInWaterFlowLayout:self];
    } else {
        return  WSLDefaultRowCount;
    }
}

-(UIEdgeInsets)edgeInsets {
    if ([self.delegate respondsToSelector:@selector(edgeInsetInWaterFlowLayout:)]) {
        return [self.delegate edgeInsetInWaterFlowLayout:self];
    } else {
        return  WSLDefaultEdgeInset;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)columnHeights {
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}
- (NSMutableArray *)rowWidths {
    if (!_rowWidths) {
        _rowWidths = [NSMutableArray array];
    }
    return _rowWidths;
}

-(NSMutableArray *)attrsArray {
    if (_attrsArray == nil) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

#pragma mark - 重写系统方法

/** 初始化 生成每个视图的布局信息*/
-(void)prepareLayout {
    
    [super prepareLayout];
    
    if (self.flowLayoutStyle == WSLWaterFlowVerticalEqualWidth) {
        
        //清除以前计算的所有高度
        self.maxColumnHeight = 0;
        [self.columnHeights removeAllObjects];
        for (NSInteger i = 0; i < self.columnCount; i++) {
            [self.columnHeights addObject:@(self.edgeInsets.top)];
        }
        
    }else if (self.flowLayoutStyle == WSLWaterFlowHorizontalEqualHeight){
        
        //清除以前计算的所有宽度
        self.maxRowWidth = 0;
        [self.rowWidths removeAllObjects];
        for (NSInteger i = 0; i < self.rowCount; i++) {
            [self.rowWidths addObject:@(self.edgeInsets.left)];
        }
        
    }else if (self.flowLayoutStyle == WSLWaterFlowVerticalEqualHeight || self.flowLayoutStyle == WSLLineWaterFlow){
        
        //记录最后一个的内容的横坐标和纵坐标
        self.maxColumnHeight = 0;
        [self.columnHeights removeAllObjects];
        [self.columnHeights addObject:@(self.edgeInsets.top)];
        
        self.maxRowWidth = 0;
        [self.rowWidths removeAllObjects];
        [self.rowWidths addObject:@(self.edgeInsets.left)];
        
    }else if(self.flowLayoutStyle == WSLWaterFlowHorizontalGrid){
        
        //记录最后一个的内容的横坐标和纵坐标
        self.maxColumnHeight = 0;
        
        self.maxRowWidth = 0;
        [self.rowWidths removeAllObjects];
        for (NSInteger i = 0; i < 2; i++) {
            [self.rowWidths addObject:@(self.edgeInsets.left)];
        }
        
    }
    
    //清除之前数组
    [self.attrsArray removeAllObjects];
    
    //开始创建每一组cell的布局属性
    NSInteger sectionCount =  [self.collectionView numberOfSections];
    for(NSInteger section = 0; section < sectionCount; section++){
        
        //获取每一组头视图header的UICollectionViewLayoutAttributes
        if([self.delegate respondsToSelector:@selector(waterFlowLayout:sizeForHeaderViewInSection:)]){
            UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            [self.attrsArray addObject:headerAttrs];
        }
        
        //开始创建组内的每一个cell的布局属性
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger row = 0; row < rowCount; row++) {
            //创建位置
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            //获取indexPath位置cell对应的布局属性
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrsArray addObject:attrs];
        }
        
        //获取每一组脚视图footer的UICollectionViewLayoutAttributes
        if([self.delegate respondsToSelector:@selector(waterFlowLayout:sizeForFooterViewInSection:)]){
            UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            [self.attrsArray addObject:footerAttrs];
        }
        
    }
}

/** 决定一段区域所有cell和头尾视图的布局属性*/
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}

/** 返回indexPath位置cell对应的布局属性*/
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //设置布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes  layoutAttributesForCellWithIndexPath:indexPath];
    
    if (self.flowLayoutStyle == WSLWaterFlowVerticalEqualWidth) {
        
        attrs.frame = [self itemFrameOfVerticalWaterFlow:indexPath];
        
    }else if (self.flowLayoutStyle == WSLWaterFlowHorizontalEqualHeight){
        
        attrs.frame = [self itemFrameOfHorizontalWaterFlow:indexPath];
        
    }else if(self.flowLayoutStyle == WSLWaterFlowVerticalEqualHeight){
        
        attrs.frame = [self itemFrameOfVHWaterFlow:indexPath];
        
    }else if(self.flowLayoutStyle == WSLLineWaterFlow){
        
        attrs.frame = [self itemFrameOfLineWaterFlow:indexPath];
        
        // 计算中心点距离
        CGFloat delta = fabs((attrs.center.x - self.collectionView.contentOffset.x) - self.collectionView.frame.size.width * 0.5);
        
        //计算比例
        CGFloat scale = 1 - delta / (self.collectionView.frame.size.width * 0.5) * 0.25;
        
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
        
    }else if (self.flowLayoutStyle == WSLWaterFlowHorizontalGrid){
        
        attrs.frame = [self itemFrameOfHorizontalGridWaterFlow:indexPath];
    }
    
    return attrs;
}

/** 返回indexPath位置头和脚视图对应的布局属性*/
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attri;
    
    if ([UICollectionElementKindSectionHeader isEqualToString:elementKind]) {
        
        //头视图
        attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        
        attri.frame = [self headerViewFrameOfVerticalWaterFlow:indexPath];
        
    }else {
        
        //脚视图
        attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
        
        attri.frame = [self footerViewFrameOfVerticalWaterFlow:indexPath];
        
    }
    
    return attri;
    
}

/** 返回值决定了collectionView停止滚动时的偏移量 手指松开后执行
 * proposedContentOffset：原本情况下，collectionView停止滚动时最终的偏移量
 * velocity 滚动速率，通过这个参数可以了解滚动的方向
 */
/*
 - (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
 {
 if (self.flowLayoutStyle == WSLLineWaterFlow) {
 // 拖动比较快 最终偏移量 不等于 手指离开时偏移量
 CGFloat collectionW = self.collectionView.frame.size.width;
 
 // 最终偏移量
 CGPoint targetP = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
 
 // 0.获取最终显示的区域
 CGRect targetRect = CGRectMake(targetP.x, 0, collectionW, MAXFLOAT);
 
 // 1.获取最终显示的cell
 NSArray *attrs = [super layoutAttributesForElementsInRect:targetRect];
 
 // 获取最小间距
 CGFloat minDelta = MAXFLOAT;
 for (UICollectionViewLayoutAttributes *attr in attrs) {
 // 获取距离中心点距离:注意:应该用最终的x
 CGFloat delta = (attr.center.x - targetP.x) - self.collectionView.bounds.size.width * 0.5;
 
 if (fabs(delta) < fabs(minDelta)) {
 minDelta = delta;
 }
 }
 
 // 移动间距
 targetP.x += minDelta;
 
 if (targetP.x < 0) {
 targetP.x = 0;
 }
 
 return targetP;
 
 }
 return proposedContentOffset;
 
 }
 // Invalidate:刷新
 // 在滚动的时候是否允许刷新布局
 - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
 
 if (self.flowLayoutStyle == WSLLineWaterFlow) {
 return YES;
 }
 
 return NO;
 }
 */
//返回内容高度
-(CGSize)collectionViewContentSize {
    
    if (self.flowLayoutStyle == WSLWaterFlowVerticalEqualWidth) {
        
        return CGSizeMake(0, self.maxColumnHeight + self.edgeInsets.bottom);
        
    }else if (self.flowLayoutStyle == WSLWaterFlowHorizontalEqualHeight){
        
        return CGSizeMake(self.maxRowWidth + self.edgeInsets.right, 0);
        
    }else if(self.flowLayoutStyle == WSLWaterFlowVerticalEqualHeight){
        
        return CGSizeMake(0 , self.maxColumnHeight + self.edgeInsets.bottom);
    }else if(self.flowLayoutStyle == WSLLineWaterFlow){
        
        return CGSizeMake(self.maxRowWidth + self.edgeInsets.right , 0);
    }else if(self.flowLayoutStyle == WSLWaterFlowHorizontalGrid){
        
        return CGSizeMake(self.maxRowWidth + self.edgeInsets.right,self.collectionView.frame.size.height);
    }
    
    return CGSizeMake(0, 0);
    
}

#pragma mark - Help Methods

//竖向瀑布流 item等宽不等高
- (CGRect)itemFrameOfVerticalWaterFlow:(NSIndexPath *)indexPath{
    
    //collectionView的宽度
    CGFloat collectionW = self.collectionView.frame.size.width;
    //设置布局属性item的frame
    CGFloat w = (collectionW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    CGFloat h = [self.delegate waterFlowLayout:self sizeForItemAtIndexPath:indexPath].height;
    
    //找出高度最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        //取出第i列
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    
    //更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(CGRectMake(x, y, w, h)));
    //记录内容的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.maxColumnHeight < columnHeight) {
        self.maxColumnHeight = columnHeight;
    }
    
    return CGRectMake(x, y, w, h);
}

//竖向瀑布流 item等高不等宽
- (CGRect)itemFrameOfVHWaterFlow:(NSIndexPath *)indexPath{
    
    //collectionView的宽度
    CGFloat collectionW = self.collectionView.frame.size.width;
    
    CGSize headViewSize = CGSizeMake(0, 0);
    if([self.delegate respondsToSelector:@selector(waterFlowLayout:sizeForHeaderViewInSection:)]){
        headViewSize = [self.delegate waterFlowLayout:self sizeForHeaderViewInSection:indexPath.section];
    }
    
    CGFloat w = [self.delegate waterFlowLayout:self sizeForItemAtIndexPath:indexPath].width;
    CGFloat h = [self.delegate waterFlowLayout:self sizeForItemAtIndexPath:indexPath].height;
    
    CGFloat x;
    CGFloat y;
    
    //记录最后一行的内容的横坐标和纵坐标
    if (collectionW - [[self.rowWidths firstObject] floatValue] > w + self.edgeInsets.right) {
        
        x = [[self.rowWidths firstObject] floatValue] == self.edgeInsets.left  ? self.edgeInsets.left : [[self.rowWidths firstObject] floatValue] + self.columnMargin;
        if ([[self.columnHeights firstObject] floatValue] == self.edgeInsets.top) {
            y = self.edgeInsets.top;
        }else if ([[self.columnHeights firstObject] floatValue] == self.edgeInsets.top + headViewSize.height) {
            y =  self.edgeInsets.top + headViewSize.height + self.rowMargin;
        }else{
            y = [[self.columnHeights firstObject] floatValue] - h;
        }
        [self.rowWidths replaceObjectAtIndex:0 withObject:@(x + w )];
        
        if ([[self.columnHeights firstObject] floatValue] == self.edgeInsets.top || [[self.columnHeights firstObject] floatValue] == self.edgeInsets.top + headViewSize.height) {
            [self.columnHeights replaceObjectAtIndex:0 withObject:@(y + h)];
        }
        
    }else if(collectionW - [[self.rowWidths firstObject] floatValue] == w + self.edgeInsets.right){
        //换行
        x = self.edgeInsets.left;
        y = [[self.columnHeights firstObject] floatValue] + self.rowMargin;
        [self.rowWidths replaceObjectAtIndex:0 withObject:@(x + w)];
        [self.columnHeights replaceObjectAtIndex:0 withObject:@(y + h)];
        
    }else{
        //换行
        x = self.edgeInsets.left;
        y = [[self.columnHeights firstObject] floatValue]  + self.rowMargin;
        [self.rowWidths replaceObjectAtIndex:0 withObject:@(x + w)];
        [self.columnHeights replaceObjectAtIndex:0 withObject:@(y + h)];
    }
    
    //记录内容的高度
    self.maxColumnHeight = [[self.columnHeights firstObject] floatValue] ;
    
    return CGRectMake(x, y, w, h);
    
}

//水平瀑布流 item等高不等宽
- (CGRect)itemFrameOfHorizontalWaterFlow:(NSIndexPath *)indexPath{
    
    //collectionView的高度
    CGFloat collectionH = self.collectionView.frame.size.height;
    //设置布局属性item的frame
    CGFloat h = (collectionH - self.edgeInsets.top - self.edgeInsets.bottom - (self.rowCount - 1) * self.rowMargin) / self.rowCount;
    CGFloat w = [self.delegate waterFlowLayout:self sizeForItemAtIndexPath:indexPath].width;
    
    //找出宽度最短的那一行
    NSInteger destRow = 0;
    CGFloat minRowWidth = [self.rowWidths[0] doubleValue];
    for (NSInteger i = 1; i < self.rowWidths.count; i++) {
        //取出第i行
        CGFloat rowWidth = [self.rowWidths[i] doubleValue];
        if (minRowWidth > rowWidth) {
            minRowWidth = rowWidth;
            destRow = i;
        }
    }
    
    CGFloat y = self.edgeInsets.top + destRow * (h + self.rowMargin);
    CGFloat x = minRowWidth;
    if (x != self.edgeInsets.left) {
        x += self.columnMargin;
    }
    
    //更新最短那行的宽度
    self.rowWidths[destRow] = @(CGRectGetMaxX(CGRectMake(x, y, w, h)));
    //记录内容的宽度
    CGFloat rowWidth = [self.rowWidths[destRow] doubleValue];
    if (self.maxRowWidth < rowWidth) {
        self.maxRowWidth = rowWidth ;
    }
    
    return CGRectMake(x, y, w, h);
    
}

//水平栅格布局
- (CGRect)itemFrameOfHorizontalGridWaterFlow:(NSIndexPath *)indexPath{
    
    //collectionView的高度
    CGFloat collectionH = self.collectionView.frame.size.height;
    //设置布局属性item的frame
    CGFloat h = [self.delegate waterFlowLayout:self sizeForItemAtIndexPath:indexPath].height;
    CGFloat w = [self.delegate waterFlowLayout:self sizeForItemAtIndexPath:indexPath].width;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    //找出宽度最短的那一行
    NSInteger destRow = 0;
    CGFloat minRowWidth = [self.rowWidths[destRow] doubleValue];
    for (NSInteger i = 1; i < self.rowWidths.count; i++) {
        //取出第i行
        CGFloat rowWidth = [self.rowWidths[i] doubleValue];
        if (minRowWidth > rowWidth) {
            minRowWidth = rowWidth;
            destRow = i;
        }
    }
    
    y = destRow == 0 ? self.edgeInsets.top : self.edgeInsets.top + h + self.rowMargin;
    
    x = [self.rowWidths[destRow] doubleValue] == self.edgeInsets.left ? self.edgeInsets.left : [self.rowWidths[destRow] doubleValue] + self.columnMargin;
    //更新最短那行的宽度
    if (h >= collectionH - self.edgeInsets.bottom - self.edgeInsets.top) {
        x = [self.rowWidths[destRow] doubleValue] == self.edgeInsets.left ? self.edgeInsets.left : self.maxRowWidth + self.columnMargin;
        for (NSInteger i = 0; i < 2; i++) {
            self.rowWidths[i] = @(x + w);
        }
    }else{
        self.rowWidths[destRow] = @(x + w);
    }
    //记录最大宽度
    if (self.maxRowWidth < x + w) {
        self.maxRowWidth = x + w ;
    }
    
    return CGRectMake(x, y, w, h);
    
}

- (CGRect)itemFrameOfLineWaterFlow:(NSIndexPath *)indexPath{
    
    //collectionView的高度
    CGFloat collectionH = self.collectionView.frame.size.height;
    //设置布局属性item的frame
    CGFloat h = [self.delegate waterFlowLayout:self sizeForItemAtIndexPath:indexPath].height;
    CGFloat w = [self.delegate waterFlowLayout:self sizeForItemAtIndexPath:indexPath].width;
    
    CGFloat y = self.edgeInsets.top;
    CGFloat x = [[self.rowWidths firstObject] floatValue];
    if (x != self.edgeInsets.left) {
        x += self.columnMargin;
    }
    
    //更新内容的宽度
    [self.rowWidths replaceObjectAtIndex:0 withObject:@(x + w)];
    //记录内容的宽度
    self.maxRowWidth = [[self.rowWidths firstObject] floatValue];
    
    return CGRectMake(x, y, w, h);
}

//返回头视图的布局frame
- (CGRect)headerViewFrameOfVerticalWaterFlow:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeZero;
    
    if([self.delegate respondsToSelector:@selector(waterFlowLayout:sizeForHeaderViewInSection:)]){
        size = [self.delegate waterFlowLayout:self sizeForHeaderViewInSection:indexPath.section];
    }
    
    if (self.flowLayoutStyle == WSLWaterFlowVerticalEqualWidth) {
        
        CGFloat x = 0;
        CGFloat y = self.maxColumnHeight == 0 ? self.edgeInsets.top : self.maxColumnHeight;
        if (![self.delegate respondsToSelector:@selector(waterFlowLayout:sizeForFooterViewInSection:)] || [self.delegate waterFlowLayout:self sizeForFooterViewInSection:indexPath.section].height == 0) {
            y = self.maxColumnHeight == 0 ? self.edgeInsets.top : self.maxColumnHeight + self.rowMargin;
        }
        
        self.maxColumnHeight = y + size.height ;
        
        [self.columnHeights removeAllObjects];
        for (NSInteger i = 0; i < self.columnCount; i++) {
            [self.columnHeights addObject:@(self.maxColumnHeight)];
        }
        
        return CGRectMake(x , y, self.collectionView.frame.size.width, size.height);
        
    }else if (self.flowLayoutStyle == WSLWaterFlowVerticalEqualHeight){
        
        CGFloat x = 0;
        CGFloat y = self.maxColumnHeight == 0 ? self.edgeInsets.top : self.maxColumnHeight;
        if (![self.delegate respondsToSelector:@selector(waterFlowLayout:sizeForFooterViewInSection:)] || [self.delegate waterFlowLayout:self sizeForFooterViewInSection:indexPath.section].height == 0) {
            y = self.maxColumnHeight == 0 ? self.edgeInsets.top : self.maxColumnHeight + self.rowMargin;
        }
        
        self.maxColumnHeight = y + size.height ;
        
        [self.rowWidths replaceObjectAtIndex:0 withObject:@(self.collectionView.frame.size.width)];
        [self.columnHeights replaceObjectAtIndex:0 withObject:@(self.maxColumnHeight)];
        
        return CGRectMake(x , y, self.collectionView.frame.size.width, size.height);
        
        
    }else if (self.flowLayoutStyle == WSLWaterFlowHorizontalEqualHeight){
        
        
        
    }
    
    return CGRectMake(0, 0, 0, 0);
    
}
//返回脚视图的布局frame
- (CGRect)footerViewFrameOfVerticalWaterFlow:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeZero;
    
    if([self.delegate respondsToSelector:@selector(waterFlowLayout:sizeForFooterViewInSection:)]){
        size = [self.delegate waterFlowLayout:self sizeForFooterViewInSection:indexPath.section];
    }
    
    if (self.flowLayoutStyle == WSLWaterFlowVerticalEqualWidth ) {
        
        CGFloat x = 0;
        CGFloat y = size.height == 0 ? self.maxColumnHeight : self.maxColumnHeight + self.rowMargin;
        
        self.maxColumnHeight = y + size.height;
        
        [self.columnHeights removeAllObjects];
        for (NSInteger i = 0; i < self.columnCount; i++) {
            [self.columnHeights addObject:@(self.maxColumnHeight)];
        }
        
        return  CGRectMake(x , y, self.collectionView.frame.size.width, size.height);
        
    }else if (self.flowLayoutStyle == WSLWaterFlowVerticalEqualHeight){
        
        CGFloat x = 0;
        CGFloat y = size.height == 0 ? self.maxColumnHeight : self.maxColumnHeight + self.rowMargin;
        
        self.maxColumnHeight = y + size.height;
        
        [self.rowWidths replaceObjectAtIndex:0 withObject:@(self.collectionView.frame.size.width)];
        [self.columnHeights replaceObjectAtIndex:0 withObject:@(self.maxColumnHeight)];
        
        return  CGRectMake(x , y, self.collectionView.frame.size.width, size.height);
        
    }else if (self.flowLayoutStyle == WSLWaterFlowHorizontalEqualHeight){
        
        
        
    }
    
    return CGRectMake(0, 0, 0, 0);
    
}

@end
