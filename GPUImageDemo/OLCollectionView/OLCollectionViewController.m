//
//  OLCollectionViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/18.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLCollectionViewController.h"
#import "OLCollectionView.h"
#import "OLCollectionViewLayout.h"
#import "OLViewLayoutOne.h"
#import "OLCellOne.h"
#import "OLCirleLayout.h"
#import "OLReusableHeaderView.h"
#import "OLReusableFooterView.h"
#import "OLCollectionModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString * CellOneId = @"cellOneId";
static NSString * HeaderViewId =  @"HeaderViewId";
static NSString * FooterViewId =  @"FooterViewId";
@interface OLCollectionViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)OLCollectionView *displayCollectionView;
@property (nonatomic,strong)OLCollectionViewLayout *displayViewLayout;
@property (nonatomic,strong)OLViewLayoutOne *layoutOne;
@property (nonatomic,strong)OLCirleLayout  *circleLayout;
@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation OLCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.displayCollectionView];
    self.dataArray = @[].mutableCopy;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            
            return nil;
        }] delay:1] subscribeNext:^(id x) {
            
            for (int i = 0; i<20; i++) {
                OLCollectionModel * model = [[OLCollectionModel alloc] init];
                model.name = [NSString stringWithFormat:@"hello %d",i];
                [self.dataArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.displayCollectionView reloadData];
            });
        }] ;
    });
    
  

}

- (OLCollectionView*)displayCollectionView {
    if (!_displayCollectionView) {
        _displayCollectionView = [[OLCollectionView alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width , 500) collectionViewLayout:self.flowLayout];
        [_displayCollectionView registerClass:[OLCellOne class] forCellWithReuseIdentifier:CellOneId];
        [_displayCollectionView registerClass:[OLReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderViewId];
        [_displayCollectionView registerClass:[OLReusableFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterViewId];
        _displayCollectionView.delegate = self;
        _displayCollectionView.dataSource = self;
        _displayCollectionView.scrollEnabled = YES;
        
    }
    return _displayCollectionView;
}

- (OLCollectionViewLayout*)displayViewLayout {
    if (!_displayViewLayout) {
        _displayViewLayout = [[OLCollectionViewLayout alloc] init];
    }
    return _displayViewLayout;
}

- (OLViewLayoutOne*)layoutOne {
    if (!_layoutOne) {
        _layoutOne = [[OLViewLayoutOne alloc] init];
    }
    return _layoutOne;
}
- (OLCirleLayout*)circleLayout {
    if (!_circleLayout) {
        _circleLayout = [[OLCirleLayout alloc] init];
    }
    return _circleLayout;
}


/**
 系统的流水布局
 @property (nonatomic) CGFloat minimumLineSpacing;
 @property (nonatomic) CGFloat minimumInteritemSpacing;
 @property (nonatomic) CGSize itemSize;
 @property (nonatomic) CGSize estimatedItemSize NS_AVAILABLE_IOS(8_0); // defaults to CGSizeZero - setting a non-zero size enables cells that self-size via -preferredLayoutAttributesFittingAttributes:
 @property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical
 @property (nonatomic) CGSize headerReferenceSize;
 @property (nonatomic) CGSize footerReferenceSize;
 @property (nonatomic) UIEdgeInsets sectionInset;
 */
- (UICollectionViewFlowLayout*)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(50, 50);
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 1.0f;
        _flowLayout.estimatedItemSize = CGSizeMake(10, 10);
        _flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width - 40, 100);
        _flowLayout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width - 40, 100);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
    }
    return _flowLayout;
}

#pragma mark UICollectionDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OLCellOne * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellOneId forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    
    cell.longPressBlock = ^(OLCellOne *cell,UILongPressGestureRecognizer *longPress) {
             //获取此次点击的坐标，根据坐标获取cell对应的indexPath
           NSIndexPath *indexPath = [_displayCollectionView indexPathForCell:cell];
            //根据长按手势的状态进行处理。
            switch (longPress.state) {
                case UIGestureRecognizerStateBegan:
                    //当没有点击到cell的时候不进行处理
                    if (!indexPath) {
                        break;
                    }
                    //开始移动
                    [_displayCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
                    break;
                case UIGestureRecognizerStateChanged:
                    //移动过程中更新位置坐标
                    [_displayCollectionView updateInteractiveMovementTargetPosition:[longPress locationInView:_displayCollectionView]];
                    break;
                case UIGestureRecognizerStateEnded:
                    //停止移动调用此方法
                    [_displayCollectionView endInteractiveMovement];
                    break;
                default:
                    //取消移动
                    [_displayCollectionView cancelInteractiveMovement];
                    break;
            }
 
    };
    return cell;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        OLReusableHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderViewId forIndexPath:indexPath];
        return headerView;
        
    }else {
        OLReusableFooterView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterViewId forIndexPath:indexPath];
        return footerView;
    }
    
}


#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    OLCollectionModel *model = self.dataArray[indexPath.row];
//    return model.modelSize;
    if (indexPath.row %2 == 0 || indexPath.row%5==0) {
        return CGSizeMake(100, 100);
    }else {
        return CGSizeMake(50, 120);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//
//}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section %3 == 0) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 150);
    }else {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 80);
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section %3 != 0) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 150);
    }else {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 80);
    }
}

#pragma mark UICollectionDelegate


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return  YES;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
} // called when the user taps on an already-selected item in multi-select mode
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView performBatchUpdates:^{
        [self.dataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    
}
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
}




// These methods provide support for copy/paste actions on cells.
// All three should be implemented if any are.
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    
}



- (nonnull UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout {
    
    return nil;
}


// 移动的代理方法，下面的代理方法会和上面冲突。。。
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0) {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
    
    id objc = [self.dataArray objectAtIndex:sourceIndexPath.item];
    if (destinationIndexPath.section == 0) {
        [self.dataArray removeObject:objc];
        [self.dataArray insertObject:objc atIndex:destinationIndexPath.item];
    }
}

//
//// Focus
//- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0) {
//
//    return YES;
//}
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context NS_AVAILABLE_IOS(9_0) {
//
//    return YES;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator NS_AVAILABLE_IOS(9_0) {
//
//}
//- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInCollectionView:(UICollectionView *)collectionView NS_AVAILABLE_IOS(9_0){
//
//    return nil;
//}
//
//- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath NS_AVAILABLE_IOS(9_0) {
//
//    return nil;
//}
//
//- (CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset NS_AVAILABLE_IOS(9_0){
//    return CGPointZero;
//} // customize the content offset to be applied during transition or update animations



// Spring Loading

/* Allows opting-out of spring loading for an particular item.
 *
 * If you want the interaction effect on a different subview of the spring loaded cell, modify the context.targetView property.
 * The default is the cell.
 *
 * If this method is not implemented, the default is YES.
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSpringLoadItemAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos) {
    
    return YES;
}




@end
