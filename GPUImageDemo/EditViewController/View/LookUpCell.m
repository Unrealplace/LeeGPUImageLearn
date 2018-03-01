
//
//  LookUpCell.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/1.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "LookUpCell.h"


@interface LookUpCell ()

@property (nonatomic,strong)UIImageView * showImgView;

@end

@implementation LookUpCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.showImgView = [UIImageView new];
        [self.contentView addSubview:self.showImgView];
    }
    return self;
}
- (void)layoutSubviews {
    self.showImgView.frame = self.bounds;
}
- (void)setImgWith:(UIImage*)img {
    self.showImgView.image = img;
}



@end
