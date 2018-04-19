//
//  OLCirleLayout.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/18.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLCirleLayout.h"

@interface OLCirleLayout()
@property (nonatomic,strong)NSMutableDictionary * attributesDic;
@property (nonatomic,strong)NSMutableArray *attrsArr;

@end

@implementation OLCirleLayout


-(NSMutableArray *)attrsArr
{
    if(!_attrsArr){
        _attrsArr=[[NSMutableArray alloc] init];
    }
    return _attrsArr;
}
- (instancetype)init {
    if (self = [super init]) {
        self.attributesDic = @{}.mutableCopy;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    [self.attrsArr removeAllObjects];
//    [self.attributesDic removeAllObjects];
//    [self setAttributes];
    [self creatAttrs];
}

- (void)creatAttrs {
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i =0; i<count; i++) {
        NSIndexPath * indexpath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexpath];
        [self.attrsArr addObject:attrs];
    }
    
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArr;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = [self.collectionView numberOfItemsInSection:indexPath.section];
    //角度
    CGFloat angle = 2* M_PI /count *indexPath.item;
    //设置半径
    CGFloat radius=60;
    //CollectionView的圆心的位置
    CGFloat Ox = self.collectionView.frame.size.width/2;
    CGFloat Oy = self.collectionView.frame.size.height/2;
    UICollectionViewLayoutAttributes * attrs=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.center = CGPointMake(Ox+radius*sin(angle), Oy+radius*cos(angle));
    if (count==1) {
        attrs.size=CGSizeMake(200, 200);
    }else
    {
        attrs.size=CGSizeMake(30, 30);
    }

    return attrs;
}

- (void)setAttributes {
   NSInteger section = [self.collectionView numberOfSections];
    for (int i =0; i <section; i++) {
        NSInteger itemNum = [self.collectionView numberOfItemsInSection:i];
        NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:itemNum];
        for (int j = 0; j <itemNum; j++) {
            //创建UICollectionViewLayoutAttributes
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            //这里需要 告诉 UICollectionViewLayoutAttributes 是哪里的attrs
            UICollectionViewLayoutAttributes * attrs=[self layoutAttributesForItemAtIndexPath:indexPath];
            [itemArray addObject:attrs];
            [self.attributesDic setObject:itemArray forKey:@(i)];
            [self.attrsArr addObjectsFromArray:itemArray];
        }
    }
}

@end
