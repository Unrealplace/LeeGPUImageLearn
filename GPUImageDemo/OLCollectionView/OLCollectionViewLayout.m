//
//  OLCollectionViewLayout.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/18.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLCollectionViewLayout.h"

@implementation OLCollectionViewLayout

/**
 返回collectionView内容区的宽度和高度，子类必须重载该方法，返回值代表了所有内容的宽度和高度，而不仅仅是可见范围的，
 collectionView通过该信息配置它的滚动范围，默认返回 CGSizeZero。
 */
- (CGSize)collectionViewContentSize {
    
    return CGSizeZero;
}



- (void)prepareLayout {
    
}

/**
 除了这些方法之外，你也可以重载- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems;
 做一些和布局相关的准备工作。也可以重载- (void)finalizeCollectionViewUpdates;通过该方法添加一些动画到block，或者做一些和最终布局相关的工作。
 */
- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    
}

- (void)finalizeCollectionViewUpdates {
    
}



/**
 返回UICollectionViewLayoutAttributes 类型的数组，UICollectionViewLayoutAttributes 对象包含cell或view的布局信息。
 子类必须重载该方法，并返回该区域内所有元素的布局信息，包括cell,追加视图和装饰视图。
 在创建 layout attributes的时候，创建的是相应元素类型(cell, supplementary, decoration)的 attributes对象,比如：
 
 */
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return nil;
}


/**
 返回指定indexPath的item的布局信息。
 子类必须重载该方法,该方法只能为cell提供布局信息，不能为补充视图和装饰视图提供。
 */
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

/**
 如果你的布局支持追加视图的话，必须重载该方法，该方法返回的是追加视图的布局信息，
 kind这个参数区分段头还是段尾的，在collectionview注册的时候回用到该参数。
 */
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

/**
 如果你的布局支持装饰视图的话，必须重载该方法，该方法返回的是装饰视图的布局信息，
 ecorationViewKind这个参数在collectionview注册的时候回用到

 */
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


/**
 当item在手势交互下移动时，通过该方法返回这个item布局的attributes 。
 默认实现是，复制已存在的attributes，改变attributes两个值，一个是中心点center；另一个是z轴的坐标值，设置成最大值。
 所以该item在collection view的最上层。子类重载该方法，可以按照自己的需求更改attributes，首先需要调用super类获取attributes,然后自定义返回的数据结构。
 
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForInteractivelyMovingItemAtIndexPath:(NSIndexPath *)indexPath withTargetPosition:(CGPoint)position {
    return nil;
}



/**
 当collection view的数据发生改变的时候，比如插入或者删除 item的时候，collection view将会要求布局对象更新相应的布局信息。
 移动、添加、删除 items时都必须更新相应的布局信息以便反映元素最新的位置。
 对于移动的元素， collection view提供了标准的方法获取更新后的布局信息。
 而collection view删除或者添加元素的时候，将会调用一些不同的方法，你应该重载以便提供正确的布局信息：

 */

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    
    return nil;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {

    return nil;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath {
    
    return nil;
}



/**
 返回值是item即将从collection view移除时候的布局信息，对即将删除的item来讲，
 该方法在 prepareForCollectionViewUpdates: 之后和finalizeCollectionViewUpdates 之前调用。
 在该方法中返回的布局信息描包含 item的状态信息和位置信息。
 collection view将会把该信息作为动画的终点(起点是item当前的位置)。如果返回为nil的话，布局对象将会把当前的attribute，作为动画的起点和终点。
 
 */
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    return nil;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath {
    return nil;
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    return nil;
}



/**
 在进行动画式布局的时候，该方法返回内容区的偏移量。
 在布局更新或者布局转场的时候，collection view 调用该方法改变内容区的偏移量，该偏移量作为动画的结束点。
 如果动画或者转场造成item位置的改变并不是以最优的方式进行，可以重载该方法进行优化。
 collection view在调用prepareLayout 和 collectionViewContentSize 之后调用该方法
 
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    
    return CGPointZero;
}

/**
 该方法返回值为滑动停止的点。如果你希望内容区快速滑动到指定的区域，可以重载该方法。
 比如，你可以通过该方法让滑动停止在两个item中间的区域，而不是某个item的中间。
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    return CGPointZero;
    
}



/**
 返回一个NSIndexPath 类型的数组，该数组存放的是将要从collection view中插入或删除的追加视图的 NSIndexPath 。
 从collection view删除cell或者section的时候，就会调用该方法。
 collection view将会在prepareForCollectionViewUpdates: 和finalizeCollectionViewUpdates之间调用该方法。
 
 */
- (NSArray<NSIndexPath*>*)indexPathsToInsertForSupplementaryViewOfKind:(NSString *)elementKind {
    
    return nil;
}
- (NSArray<NSIndexPath*>*)indexPathsToDeleteForSupplementaryViewOfKind:(NSString *)elementKind {
    return nil;
}
- (NSArray<NSIndexPath*>*)indexPathsToInsertForDecorationViewOfKind:(NSString *)elementKind {
    return nil;
}
- (NSArray<NSIndexPath*>*)indexPathsToDeleteForDecorationViewOfKind:(NSString *)elementKind {
    return nil;
}



/**
 使布局失效
 */
- (void)invalidateLayout {
    
}

/**
 该方法用来决定是否需要更新布局。如果collection view需要重新布局返回YES,否则返回NO,默认返回值为NO。
 
 子类重载该方法的时候，基于是否collection view的bounds的改变会引发cell和view布局的改变，给出正确的返回值。
 
 如果collection view的bounds改变,该方法返回YES，collection view通过调用
 invalidateLayoutWithContext方法使原来的layout失效
 
 这些方法为collection view 在屏幕上布局提供了最基础的布局信息，如果你不想为追加视图和装饰视图布局，可以不去重载相应的方法。

 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds {
    return nil;
}
//
//- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes {
//
//}
//- (UICollectionViewLayoutInvalidationContext *)invalidationContextForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes {
//
//}


@end
