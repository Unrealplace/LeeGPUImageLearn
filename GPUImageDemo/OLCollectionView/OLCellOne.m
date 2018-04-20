//
//  OLCellOne.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/18.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLCellOne.h"

@interface OLCellOne()

@property (nonatomic,strong)UILabel * titleLabel;

@end

@implementation OLCellOne

- (void)prepareForReuse {
    [super prepareForReuse];
    self.backgroundColor = [UIColor redColor];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureClick:)];
        self.longPressGesture.minimumPressDuration= .5f;
        [self addGestureRecognizer:self.longPressGesture];
        self.titleLabel = [UILabel new];
        self.titleLabel.frame = self.bounds;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}


// Override these methods to provide custom UI for specific layouts.
- (void)willTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout {

    
}
- (void)didTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout {
    
    
}

//- (UICollectionViewLayoutAttributes*)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes {
//    
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
//    
//    CGSize size = [self.contentView systemLayoutSizeFittingSize: layoutAttributes.size];
//    CGRect cellFrame = layoutAttributes.frame;
//    cellFrame.size.height= size.height;
//    layoutAttributes.frame= cellFrame;
//    return layoutAttributes;
//    
//}




- (void)longPressGestureClick:(UILongPressGestureRecognizer*)gester {
    if (self.longPressBlock) {
        self.longPressBlock(self,gester);
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
}

- (void)setSelected:(BOOL)selected {
    self.backgroundColor = [UIColor yellowColor];
}

- (void)setModel:(OLCollectionModel *)model {
    self.titleLabel.text = model.name;

}


@end
