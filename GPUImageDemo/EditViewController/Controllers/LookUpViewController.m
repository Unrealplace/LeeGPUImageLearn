//
//  LookUpViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/1.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "LookUpViewController.h"
#import "LookUpCell.h"

static NSString * lookUpCellID = @"lookUpCellID";

@interface LookUpViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView * showCollectionView;

@end

@implementation LookUpViewController

- (void)loadView {
    [super loadView];
    self.view.bounds = CGRectMake(0, 0, 375, 80);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.showCollectionView];
}


- (UICollectionView*)showCollectionView {
    if (!_showCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(80, 80);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _showCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
        _showCollectionView.delegate = self;
        _showCollectionView.dataSource = self;
        _showCollectionView.scrollEnabled = YES;
        _showCollectionView.showsHorizontalScrollIndicator = NO;
        _showCollectionView.backgroundColor = [UIColor clearColor];
        [_showCollectionView registerClass:[LookUpCell class] forCellWithReuseIdentifier:lookUpCellID];
    }
    return _showCollectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.lookUpFilters.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
 
    LookUpCell * lookUpCell = [collectionView dequeueReusableCellWithReuseIdentifier:lookUpCellID forIndexPath:indexPath];
    NSDictionary * dic = self.lookUpFilters[indexPath.item];
    UIImage * img = [UIImage imageWithContentsOfFile:[self preImgWith:dic[@"preImageName"]]];
    [lookUpCell setImgWith:img];
    NSLog(@"%@",dic);
    return lookUpCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = self.lookUpFilters[indexPath.item];
    UIImage * lookUpImg = [UIImage imageWithContentsOfFile:[self preImgWith:dic[@"LUTPicName"]]];
    if (self.lookUpClickBlock) {
        self.lookUpClickBlock(lookUpImg);
    }
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}

- (NSString*)preImgWith:(NSString*)imgName {
    NSString * plistPath =  [[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"Filters"] stringByAppendingPathComponent:imgName];
    NSLog(@"%@",plistPath);
    return plistPath;

}

- (NSArray*)lookUpFilters {
   NSString * plistPath =  [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"Filters.plist"];
   return [NSArray arrayWithContentsOfFile:plistPath];
}


@end
