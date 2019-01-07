简书地址：https://www.jianshu.com/p/9fafd89c97ad

![瀑布流](https://upload-images.jianshu.io/upload_images/1708447-8f235c82675a23c4.gif?imageMogr2/auto-orient/strip)

>功能描述：[WSLWaterFlowLayout]() 是在继承于UICollectionViewLayout的基础上封装的控件， 目前支持竖向瀑布流(item等宽不等高、支持头脚视图)、水平瀑布流(item等高不等宽 不支持头脚视图)、竖向瀑布流( item等高不等宽、支持头脚视图)、栅格布局瀑布流 4种样式的瀑布流布局。

* 前言 ：近几个月一直在忙公司的ChinaDaily项目，没有抽出时间来写简书，现在终于算是告一段落了，抽出时间来更一篇😁

* 实现：主要是重写父类的几个涉及布局属性的方法，在对应的布局属性方法中根据需求自定义视图布局属性信息。详情看示例

```
/** 初始化 生成每个视图的布局信息*/
-(void)prepareLayout;
/** 决定一段区域所有cell和头尾视图的布局属性*/
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect ;
/** 返回indexPath位置cell对应的布局属性*/
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
/** 返回indexPath位置头和脚视图对应的布局属性*/
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;
//返回内容高度
-(CGSize)collectionViewContentSize;
```

* 用法：注意遵循WSLWaterFlowLayoutDelegate协议，代理方法和TableView、collectionView的代理方法用法相似。
下面是WSLWaterFlowLayout.h中的属性方法和代理方法，含义注释的还算清晰：
```
typedef enum {
    WSLWaterFlowVerticalEqualWidth = 0, /** 竖向瀑布流 item等宽不等高 */
    WSLWaterFlowHorizontalEqualHeight = 1, /** 水平瀑布流 item等高不等宽 不支持头脚视图*/
    WSLWaterFlowVerticalEqualHeight = 2,  /** 竖向瀑布流 item等高不等宽 */
    WSLWaterFlowHorizontalGrid = 3,  /** 特为国务院客户端原创栏目滑块样式定制-水平栅格布局  仅供学习交流*/
    WSLLineWaterFlow = 4 /** 线性布局 待完成，敬请期待 */
} WSLFlowLayoutStyle; //样式

@class WSLWaterFlowLayout;

@protocol WSLWaterFlowLayoutDelegate <NSObject>

/**
 返回item的大小
 注意：根据当前的瀑布流样式需知的事项：
 当样式为WSLWaterFlowVerticalEqualWidth 传入的size.width无效 ，所以可以是任意值，因为内部会根据样式自己计算布局
 WSLWaterFlowHorizontalEqualHeight 传入的size.height无效 ，所以可以是任意值 ，因为内部会根据样式自己计算布局
 WSLWaterFlowHorizontalGrid   传入的size宽高都有效， 此时返回列数、行数的代理方法无效，
 WSLWaterFlowVerticalEqualHeight 传入的size宽高都有效， 此时返回列数、行数的代理方法无效
 */
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section;
/** 脚视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section;

@optional  //以下都有默认值
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
```
 初始化仅三行代码，只需设置代理和样式，item的大小、头脚视图的大小、行列数以及间距都可以在对应样式的代理方法中自定义:
```
    WSLWaterFlowLayout * _flow = [[WSLWaterFlowLayout alloc] init];
    _flow.delegate = self;
    _flow.flowLayoutStyle = WSLVerticalWaterFlow;
```
>更新于2018/8/12：   新增样式4-栅格布局样式的瀑布流，如下图
简书地址：https://www.jianshu.com/p/f40bbe437265



![栅格布局样式](https://upload-images.jianshu.io/upload_images/1708447-baecc8e82b7c2eae.gif?imageMogr2/auto-orient/strip)

![赞.gif](http://upload-images.jianshu.io/upload_images/1708447-ce06388c244874ce.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


