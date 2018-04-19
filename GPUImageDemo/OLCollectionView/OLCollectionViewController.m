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

static NSString * CellOneId = @"cellOneId";

@interface OLCollectionViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)OLCollectionView *displayCollectionView;
@property (nonatomic,strong)OLCollectionViewLayout *displayViewLayout;
@property (nonatomic,strong)OLViewLayoutOne *layoutOne;
@property (nonatomic,strong)OLCirleLayout  *circleLayout;

@end

@implementation OLCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.displayCollectionView];
    

}

- (OLCollectionView*)displayCollectionView {
    if (!_displayCollectionView) {
        _displayCollectionView = [[OLCollectionView alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 300) collectionViewLayout:self.circleLayout];
        [_displayCollectionView registerClass:[OLCellOne class] forCellWithReuseIdentifier:CellOneId];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OLCellOne * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellOneId forIndexPath:indexPath];
    return cell;
    
}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    
//}
//


@end
