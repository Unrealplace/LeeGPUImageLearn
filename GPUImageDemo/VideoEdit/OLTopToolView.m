//
//  OLTopToolView.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLTopToolView.h"

@interface OLTopToolView ()
@property (nonatomic,strong)UIButton *backBtn;
@end

@implementation OLTopToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    [self addSubview:self.backBtn];
}

- (UIButton*)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(14, 0, 32, 32);
        _backBtn.center = CGPointMake(_backBtn.center.x, self.bounds.size.height/2.0f);
        [_backBtn setImage:[UIImage imageNamed:@"cam_ic_back_g"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)backBtnClick:(UIButton*)btn {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topToolViewClickBack:)]) {
        [self.delegate topToolViewClickBack:self];
    }
}

@end
