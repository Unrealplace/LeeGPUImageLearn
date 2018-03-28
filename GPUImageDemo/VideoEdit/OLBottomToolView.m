//
//  OLBottomToolView.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLBottomToolView.h"
#import "OLRecordButton.h"

@interface OLBottomToolView ()

/**
 中间记录的按钮
 */
@property (nonatomic,strong)OLRecordButton *centerRecordBtn;

/**
 左侧滤镜按钮
 */
@property (nonatomic,strong)UIButton *filterBtn;

/**
 右侧动态贴纸按钮
 */
@property (nonatomic,strong)UIButton *dynamicPasterBtn;

/**
 镜头模式数组
 */
@property (nonatomic,strong)NSArray  *sourceArray;
@end
@implementation OLBottomToolView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup {
    self.sourceArray = @[@"连拍",@" GIF ",@"拍照",@"视频"];
    [self addSubview:self.centerRecordBtn];
    [self addSubview:self.filterBtn];
    [self addSubview:self.dynamicPasterBtn];
}

- (OLRecordButton*)centerRecordBtn {
    if (!_centerRecordBtn) {
        _centerRecordBtn = [[OLRecordButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _centerRecordBtn.backgroundColor = [UIColor redColor];
        _centerRecordBtn.center = CGPointMake(self.bounds.size.width/2.0f, 14);
    }
    return _centerRecordBtn;
}

- (UIButton*)filterBtn {
    if (!_filterBtn) {
        _filterBtn = [UIButton new];
        [_filterBtn setImage:[UIImage imageNamed:@"cam_ic_filter_g"] forState:UIControlStateNormal];
        _filterBtn.frame = CGRectMake(CGRectGetMinX(_centerRecordBtn.frame) - 28 * 3, 0, 28, 28);
        _filterBtn.center = CGPointMake(_filterBtn.center.x, _centerRecordBtn.center.y);
        [_filterBtn addTarget:self action:@selector(filterBtnClick:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterBtn;
}

- (UIButton*)dynamicPasterBtn {
    if (!_dynamicPasterBtn) {
        _dynamicPasterBtn = [UIButton new];
        [_dynamicPasterBtn setImage:[UIImage imageNamed:@"cam_ic_face_g"] forState:UIControlStateNormal];
        _dynamicPasterBtn.frame = CGRectMake(CGRectGetMaxX(_centerRecordBtn.frame) + 28 *2, 0, 28, 28);
        _dynamicPasterBtn.center= CGPointMake(_dynamicPasterBtn.center.x, _centerRecordBtn.center.y);
        [_dynamicPasterBtn addTarget:self action:@selector(dynamicPasterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dynamicPasterBtn;
}



- (void)filterBtnClick:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomToolViewSelectFilter:)]) {
        [self.delegate bottomToolViewSelectFilter:self];
    }
}

- (void)dynamicPasterBtnClick:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomTooleViewSelectDynamicPaster:)]) {
        [self.delegate bottomTooleViewSelectDynamicPaster:self];
    }
}

@end
