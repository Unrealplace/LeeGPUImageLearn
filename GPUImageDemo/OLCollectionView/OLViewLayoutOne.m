//
//  OLViewLayoutOne.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/18.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLViewLayoutOne.h"

@implementation OLViewLayoutOne


- (instancetype)init {
    if (self = [super init]) {
        self.itemSize = CGSizeMake(120, 120);
        self.minimumLineSpacing = 20.0;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}
/**

 -(void)prepareLayout 准备方法被自动调用，以保证layout实例的正确。
 
 -(CGSize)collectionViewContentSize 返回collectionView的内容的尺寸
 
 -(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
 1.返回rect中的所有的元素的布局属性
 2.返回的是包含UICollectionViewLayoutAttributes的NSArray
 3.UICollectionViewLayoutAttributes可以是cell，追加视图或装饰视图的信息，通过不同的UICollectionViewLayoutAttributes初始化方法可以得到不同类型的UICollectionViewLayoutAttributes：
 1)layoutAttributesForCellWithIndexPath:
 2)layoutAttributesForSupplementaryViewOfKind:withIndexPath:
 3)layoutAttributesForDecorationViewOfKind:withIndexPath:
 
 -(UICollectionViewLayoutAttributes )layoutAttributesForItemAtIndexPath:(NSIndexPath )indexPath
 返回对应于indexPath的位置的cell的布局属性
 
 -(UICollectionViewLayoutAttributes )layoutAttributesForSupplementaryViewOfKind:(NSString )kind atIndexPath:(NSIndexPath *)indexPath
 返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
 
 -(UICollectionViewLayoutAttributes * )layoutAttributesForDecorationViewOfKind:(NSString)decorationViewKind atIndexPath:(NSIndexPath )indexPath
 返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
 
 -(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
 当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
 
 
 1）-(void)prepareLayout 设置layout的结构和初始需要的参数等
 2) -(CGSize) collectionViewContentSize 确定collectionView的所有内容的尺寸。
 3）-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect初始的layout的外观将由该方法返回的UICollectionViewLayoutAttributes来决定。
 4)在需要更新layout时，需要给当前layout发送
 1)-invalidateLayout， 该消息会立即返回，并且预约在下一个loop的时候刷新当前layout
 2)-prepareLayout，
 3)依次再调用-collectionViewContentSize和-layoutAttributesForElementsInRect来生成更新后的布局。
 
 */
- (void)prepareLayout {
    [super prepareLayout];
    
}

//- (CGSize)collectionViewContentSize {
//    
//    return CGSizeMake(CGRectGetWidth(self.collectionView.frame) * 2, CGRectGetHeight(self.collectionView.frame));
//    
//}


/** * 只要手一松开就会调用 * 这个方法的返回值，就决定了CollectionView停止滚动时的偏移量 *
 proposedContentOffset这个是最终的 偏移量的值 但是实际的情况还是要根据返回值来定 * velocity 是滚动速率 有个x和y 如果x有值 说明x上有速度 * 如果y有值 说明y上又速度 还可以通过x或者y的正负来判断是左还是右（上还是下滑动） 有时候会有用
 */
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    //计算出 最终显示的矩形框
    CGRect rect;
    rect.origin.x =proposedContentOffset.x;
    rect.origin.y=0;
    rect.size=self.collectionView.frame.size;
    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    // 计算CollectionView最中心点的x值 这里要求 最终的 要考虑惯性
    CGFloat centerX = self.collectionView.frame.size.width /2+ proposedContentOffset.x;
    //存放的最小间距
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes * attrs in array) {
        if (ABS(minDelta)>ABS(attrs.center.x-centerX)) {
            minDelta=attrs.center.x-centerX;
        }
    }
    // 修改原有的偏移量
    proposedContentOffset.x+=minDelta;
    //如果返回的时zero 那个滑动停止后 就会立刻回到原地
    return proposedContentOffset;
    
}
    
/** * 这个方法的返回值是一个数组(数组里存放在rect范围内所有元素的布局属性) * 这个方法的返回值 决定了rect范围内所有元素的排布（frame） */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    CGFloat centetX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
    for (UICollectionViewLayoutAttributes * attrs in array) {
        CGFloat delta = ABS(attrs.center.x - centetX); //根据间距值 计算cell的缩放的比例
        //这里scale 必须要 小于1
        CGFloat scale = 1 - delta/self.collectionView.frame.size.width;
        //设置缩放比例
        attrs.transform=CGAffineTransformMakeScale(scale, scale);
        attrs.alpha = scale;
        
    }
    return array;
}
/*!
 * 多次调用 只要滑出范围就会 调用 *
 当CollectionView的显示范围发生改变的时候，是否重新发生布局 *
 一旦重新刷新 布局，就会重新调用 *
 1.layoutAttributesForElementsInRect：
 方法 * 2.preparelayout方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
